using Microsoft.AspNetCore.Mvc;
using Model.Responses;
using Model.SearchObjects;
using Models.Requests;
using Models.Responses;
using Models.SearchObjects;
using Services;
using Services.Database;
using Services.Interfaces;

namespace WebAPI.Controllers
{
    public class ScheduleController
        : BaseCRUDController<
            ScheduleResponse,
            ScheduleSearchObject,
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

        [HttpGet("tutor")]
        public Task<ScheduleResponse> Get([FromQuery] ScheduleSearchObject? search = null)
        {
            return _scheduleService.GetAsync(search);
        }
    }
}
