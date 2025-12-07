using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Models.Requests;
using Models.Responses;
using Models.SearchObjects;
using Services.Database;
using Services.Interfaces;
using Services.Services;

namespace Services
{
    public class ScheduleService
        : BaseCRUDService<
            ScheduleResponse,
            ScheduleSearchObject,
            TutorSchedule,
            ScheduleUpsertRequest,
            ScheduleUpsertRequest
        >,
            IScheduleService
    {
        private IUserContextService _userContextService;

        public ScheduleService(
            ApplicationDbContext context,
            IUserContextService userContextService,
            IMapper mapper
        )
            : base(context, mapper)
        {
            _userContextService = userContextService;
        }

        private int? userId => _userContextService.GetUserId();

        protected override async Task BeforeUpdate(
            TutorSchedule entity,
            ScheduleUpsertRequest request
        )
        {
            var daysToRemove = await _context
                .AvailableDays.Where(ad => ad.TutorScheduleId == entity.Id)
                .ToListAsync();

            _context.AvailableDays.RemoveRange(daysToRemove);
        }

        public async Task<ScheduleResponse?> GetAsync(ScheduleSearchObject search)
        {
            var tutor = await _context.Tutors.FirstOrDefaultAsync(t => t.Id == search.UserId);
            if (tutor == null)
            {
                throw new Exception("Tutor not found");
            }
            // Get the tutorId from the search object
            if (search == null || search.UserId == 0)
                return null;
            var tutorId = search.UserId;
            // Učitamo schedule tutora sa dostupnim danima
            var schedule = await _context
                .Schedules.Include(s => s.AvailableDays)
                .FirstOrDefaultAsync(s => s.TutorId == tutor.Id);

            if (schedule == null)
                return null;

            // Period za koji generišemo slotove (npr. narednih 7 dana)
            var startDate = DateTime.UtcNow.Date;
            var endDate = startDate.AddDays(30);

            // Povuci sve booked sesije u tom periodu
            var bookedSessions = await _context
                .StudentTutorSessions.Where(s =>
                    s.TutorId == schedule.TutorId
                    && s.StartTime >= startDate
                    && s.StartTime < endDate
                    && s.IsActive
                )
                .Select(s => s.StartTime)
                .ToListAsync();

            var slots = new List<ScheduleSlot>();
            var duration = TimeSpan.FromMinutes(schedule.Duration);
            var breakTime = TimeSpan.FromMinutes(10); // pauza između termina, po potrebi

            // Generiši slotove po danima
            for (var date = startDate; date <= endDate; date = date.AddDays(1))
            {
                var dayRule = schedule.AvailableDays.FirstOrDefault(d =>
                    d.DayOfWeek == date.DayOfWeek
                );
                if (dayRule == null)
                    continue;

                var current = dayRule.StartTime;
                while (current + duration <= dayRule.EndTime)
                {
                    var slotStart = date + current;
                    var slotEnd = slotStart + duration;

                    slots.Add(
                        new ScheduleSlot
                        {
                            Date = slotStart.Date,
                            Start = slotStart,
                            End = slotEnd,
                            IsBooked = bookedSessions.Contains(slotStart),
                        }
                    );

                    current += duration + breakTime;
                }
            }

            // Mapiraj schedule u response
            var response = _mapper.Map<ScheduleResponse>(schedule);
            Console.WriteLine(slots);
            response.Slots = slots;

            return response;
        }

        public async Task<ScheduleResponse> CreateTutorSchedule(ScheduleUpsertRequest request)
        {
            // provjeri postoji li već schedule za ovog tutora
            var schedule = await _context
                .Schedules.Include(s => s.AvailableDays)
                .FirstOrDefaultAsync(s => s.TutorId == userId!.Value);

            if (schedule == null)
            {
                // Creating new schedule - no validation needed
                schedule = new TutorSchedule
                {
                    TutorId = userId!.Value,
                    Duration = request.Duration,
                    Price = request.Price,
                    AvailableDays = request
                        .AvailableDays.Select(d => new AvailableDay
                        {
                            DayOfWeek = d.DayOfWeek,
                            StartTime = d.StartTime,
                            EndTime = d.EndTime,
                        })
                        .ToList(),
                };

                _context.Schedules.Add(schedule);
            }
            else
            {
                // Updating existing schedule - validate against booked sessions
                var now = DateTime.UtcNow;
                
                // Find the last booked appointment for this tutor
                var lastBookedSession = await _context
                    .StudentTutorSessions
                    .Where(s => s.TutorId == userId!.Value && s.IsActive && s.EndTime > now)
                    .OrderByDescending(s => s.EndTime)
                    .FirstOrDefaultAsync();

                // If there are active bookings, validate the new schedule doesn't conflict
                if (lastBookedSession != null)
                {
                    var nextAvailableDate = lastBookedSession.EndTime.Date.AddDays(1);
                    
                    // Get all future booked sessions
                    var futureBookedSessions = await _context
                        .StudentTutorSessions
                        .Where(s => s.TutorId == userId!.Value && s.IsActive && s.StartTime >= now)
                        .Select(s => new { s.StartTime, s.EndTime, DayOfWeek = s.StartTime.DayOfWeek })
                        .ToListAsync();

                    // Validate that all existing booked sessions would still be valid under the new schedule
                    foreach (var bookedSession in futureBookedSessions)
                    {
                        var newDayRule = request.AvailableDays.FirstOrDefault(d => d.DayOfWeek == bookedSession.DayOfWeek);
                        
                        if (newDayRule == null)
                        {
                            throw new InvalidOperationException(
                                $"Cannot update schedule: You have booked sessions on {bookedSession.DayOfWeek}. " +
                                $"The new schedule must include this day or cancel existing appointments first. " +
                                $"Last appointment ends on {lastBookedSession.EndTime:yyyy-MM-dd HH:mm}."
                            );
                        }

                        var sessionStartTime = bookedSession.StartTime.TimeOfDay;
                        var sessionEndTime = bookedSession.EndTime.TimeOfDay;

                        if (sessionStartTime < newDayRule.StartTime || sessionEndTime > newDayRule.EndTime)
                        {
                            throw new InvalidOperationException(
                                $"Cannot update schedule: Booked sessions exist outside the new working hours on {bookedSession.DayOfWeek}. " +
                                $"Current booking: {sessionStartTime:hh\\:mm} - {sessionEndTime:hh\\:mm}. " +
                                $"Please ensure new schedule covers these times or cancel existing appointments first. " +
                                $"Last appointment ends on {lastBookedSession.EndTime:yyyy-MM-dd HH:mm}."
                            );
                        }
                    }
                }

                // Update schedule
                schedule.Duration = request.Duration;
                schedule.Price = request.Price;

                // pobriši stare dane i dodaj nove
                _context.AvailableDays.RemoveRange(schedule.AvailableDays);

                schedule.AvailableDays = request
                    .AvailableDays.Select(d => new AvailableDay
                    {
                        DayOfWeek = d.DayOfWeek,
                        StartTime = d.StartTime,
                        EndTime = d.EndTime,
                    })
                    .ToList();
            }

            await _context.SaveChangesAsync();

            return _mapper.Map<ScheduleResponse>(schedule);
        }
    }
}
