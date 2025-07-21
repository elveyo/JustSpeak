using Model.SearchObjects;
using Models.Requests;
using Models.Responses;
using Services;
using Services.Database;
using Services.Interfaces;

namespace WebAPI.Controllers
{
    public class ScheduleController : BaseCRUDController<ScheduleResponse, BaseSearchObject, ScheduleUpsertRequest, ScheduleUpsertRequest>
    {
        public ScheduleController(IScheduleService service) : base(service)
        {
        }

    }
}