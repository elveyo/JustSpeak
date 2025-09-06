using Model.SearchObjects;
using Models.Requests;
using Models.Responses;
using Models.SearchObjects;

namespace Services.Interfaces
{
    public interface IScheduleService
        : ICRUDService<
            ScheduleResponse,
            ScheduleSearchObject,
            ScheduleUpsertRequest,
            ScheduleUpsertRequest
        >
    {
        new Task<ScheduleResponse> GetAsync(ScheduleSearchObject query);
    }
}
