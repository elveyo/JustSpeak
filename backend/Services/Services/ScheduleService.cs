using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Conventions;
using Model.Responses;
using Model.SearchObjects;
using Models.Requests;
using Models.Responses;
using Services.Database;
using Services.Interfaces;
using Services.Services;

namespace Services
{
    public class ScheduleService
        : BaseCRUDService<
            ScheduleResponse,
            BaseSearchObject,
            TutorSchedule,
            ScheduleUpsertRequest,
            ScheduleUpsertRequest
        >,
            IScheduleService
    {
        public ScheduleService(
            ApplicationDbContext context,
            IUserContextService userContextService,
            IMapper mapper
        )
            : base(context, mapper) { }

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

        public async Task<ScheduleResponse?> GetAsync(BaseSearchObject search)
        {
            int tutorId = 1;
            // Učitamo schedule tutora sa dostupnim danima
            var schedule = await _context
                .Schedules.Include(s => s.AvailableDays)
                .FirstOrDefaultAsync(s => s.TutorId == tutorId);

            if (schedule == null)
                return null;

            // Period za koji generišemo slotove (npr. narednih 7 dana)
            var startDate = DateTime.UtcNow.Date;
            var endDate = startDate.AddDays(7);

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
    }
}
