using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Model.Responses;
using Model.SearchObjects;
using Models.Requests;
using Models.Responses;
using Models.SearchObjects;
using Services.Interfaces;

namespace WebAPI.Controllers
{
    [Authorize]
    public class SessionController
        : BaseCRUDController<
            SessionResponse,
            SessionSearchObject,
            SessionUpsertRequest,
            SessionUpsertRequest
        >
    {
        private readonly ISessionService _sessionService;
        private readonly IUserContextService _userContextService;

        public SessionController(ISessionService service, IUserContextService userContextService)
            : base(service)
        {
            _sessionService = service;
            _userContextService = userContextService;
        }

        public class ChannelNameRequest
        {
            public string ChannelName { get; set; } = string.Empty;
            public string userAccount { get; set; } = string.Empty;
        }

        [HttpPost("generate-token")]
        public string GenerateToken([FromBody] ChannelNameRequest request)
        {
            return _sessionService.Get(request.ChannelName, request.userAccount);
        }

        [HttpPost("{id}/join")]
        public async Task<IActionResult> JoinSession(int id)
        {
            var success = await _sessionService.JoinSessionAsync(id);
            if (!success)
            {
                return BadRequest("Session is full or does not exist.");
            }
            return Ok();
        }

        [HttpPost("{id}/leave")]
        public async Task<IActionResult> LeaveSession(int id)
        {
            await _sessionService.LeaveSessionAsync(id);
            return Ok();
        }

        [HttpPost("{id}/start")]
        public async Task<IActionResult> StartSession(int id)
        {
            var success = await _sessionService.StartSessionAsync(id);
            if (!success)
            {
                return BadRequest("Session not found.");
            }
            return Ok();
        }

        public class CompleteSessionRequest
        {
            public string? Note { get; set; }
        }

        [HttpPost("{id}/complete")]
        public async Task<IActionResult> CompleteSession(int id, [FromBody] CompleteSessionRequest request)
        {
            var success = await _sessionService.CompleteSessionAsync(id, request.Note);
            if (!success)
            {
                return BadRequest("Session not found.");
            }
            return Ok();
        }

        [HttpPost("book-session")]
        public async Task<IActionResult> BookSession([FromBody] BookSessionRequest request)
        {
            try
            {
                var result = await _sessionService.BookSessionAsync(request);
                return Ok(result);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [HttpGet("tutor")]
        public async Task<BookedSessionResponse[]?> GetTutorSessions()
        {
            var sessions = await _sessionService.GetTutorSessionsAsync();

            return sessions;
        }

        [HttpGet("student")]
        public async Task<BookedSessionResponse[]> GetStudentSessions()
        {
            return await _sessionService.GetStudentSessionsAsync();
        }

        [HttpGet("tags")]
        public async Task<ActionResult<PagedResult<TagResponse>>> GetTags(
            [FromQuery] BaseSearchObject query
        )
        {
            var searchObject = new BaseSearchObject
            {
                Page = query.Page,
                PageSize = query.PageSize,
            };

            var pagedTags = await _sessionService.GetTagsAsync(searchObject);
            return Ok(pagedTags);
        }
        [HttpPost("rate-users")]
        public async Task<IActionResult> RateUsers([FromBody] RateUserRequest request)
        {
            await _sessionService.RateUsersAsync(request);
            return Ok();
        }
    }
}
