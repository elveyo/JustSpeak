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

        /*
                [HttpPost("tutor-schedule")]
                public async Task<IActionResult> UpsertTutorSchedule([FromBody] Models.Requests.Services.DTO.TutorScheduleUpsertRequest request, [FromServices] ITutorScheduleService tutorScheduleService)
                {
                    try
                    {
                        var result = await tutorScheduleService.UpsertTutorScheduleAsync(request);
                        return Ok(result);
                    }
                    catch (Exception ex)
                    {
                        return BadRequest(ex.Message);
                    }
                }
        
                [HttpGet("tutor-schedule")]
                public async Task<IActionResult> GetTutorSchedule([FromQuery] int tutorId, [FromServices] ITutorScheduleService tutorScheduleService)
                {
                    try
                    {
                        var result = await tutorScheduleService.GetTutorScheduleByTutorIdAsync(tutorId);
                        if (result == null)
                            return NotFound();
                        return Ok(result);
                    }
                    catch (Exception ex)
                    {
                        return BadRequest(ex.Message);
                    }
                } */
    }
}
