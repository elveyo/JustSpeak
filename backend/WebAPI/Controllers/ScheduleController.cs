using Microsoft.AspNetCore.Mvc;
using Model.Responses;
using Model.SearchObjects;
using Models.Requests;
using Models.Responses;
using Services;
using Services.Database;
using Services.Interfaces;

namespace WebAPI.Controllers
{
    public class ScheduleController
        : BaseCRUDController<
            ScheduleResponse,
            BaseSearchObject,
            ScheduleUpsertRequest,
            ScheduleUpsertRequest
        >
    {
        private readonly IScheduleService _scheduleService;

        public ScheduleController(IScheduleService service)
            : base(service)
        {
            _scheduleService = service;
        }

        [HttpGet("all")]
        public new Task<ScheduleResponse> Get([FromQuery] BaseSearchObject? search = null)
        {
            return _scheduleService.GetAsync(search);
        }
    }
}
