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
    public class ScheduleService : BaseCRUDService<ScheduleResponse, BaseSearchObject, TutorSchedule, ScheduleUpsertRequest, ScheduleUpsertRequest>, IScheduleService
    {
        public ScheduleService(ApplicationDbContext context, IMapper mapper) : base(context, mapper)
        {
        }

        protected override async Task BeforeUpdate(TutorSchedule entity, ScheduleUpsertRequest request)
        {
            var daysToRemove = await _context.AvailableDays
            .Where(ad => ad.TutorScheduleId == entity.Id)
            .ToListAsync();

            _context.AvailableDays.RemoveRange(daysToRemove);
        }

        public override async Task<PagedResult<ScheduleResponse>> GetAsync(BaseSearchObject search)
        {
            var schedule = await _context.Schedules
            .Include(s => s.AvailableDays)
            .FirstOrDefaultAsync();

            // For each schedule, generate available lessons as a list of paired TimeSpans (start, end) for each day, based on duration
         

                // Dictionary to hold available lesson time pairs for each day of week
                var availableLessons = new List<WeeklyAvailability>();


                foreach (var day in schedule.AvailableDays ?? [])
                {
                    var startTime = day.StartTime;
                    var endTime = day.EndTime;
                    var duration = TimeSpan.FromMinutes(schedule.Duration);
                    var breakTime = TimeSpan.FromMinutes(10);

                    var lessonPairs = new List<TimeSpanPair>();
                    var current = startTime;
                    while (current + duration <= endTime)
                    {
                        lessonPairs.Add(new TimeSpanPair { Start = current, End = current + duration });
                        current += duration+breakTime;
                    }
                    availableLessons.Add(new WeeklyAvailability { DayOfWeek = day.DayOfWeek, TimeSpans = lessonPairs });
                   
                }
            

            var response = _mapper.Map<ScheduleResponse>(schedule);
            response.WeeklyAvailability = availableLessons;
            return new PagedResult<ScheduleResponse> { Items = [response], TotalCount = 1 };
        }

    }
}