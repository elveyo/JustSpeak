using Model.SearchObjects;
using Models.Requests;
using Models.Responses;

namespace Services.Interfaces
{
    public interface IScheduleService
        : ICRUDService<
            ScheduleResponse,
            BaseSearchObject,
            ScheduleUpsertRequest,
            ScheduleUpsertRequest
        >
    {
        new Task<ScheduleResponse> GetAsync(BaseSearchObject query);
    }
}
