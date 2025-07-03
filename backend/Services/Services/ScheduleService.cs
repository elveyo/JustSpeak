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

        public override Task<PagedResult<ScheduleResponse>> GetAsync(BaseSearchObject search)
        {
            return base.GetAsync(search);
        }

    }
}