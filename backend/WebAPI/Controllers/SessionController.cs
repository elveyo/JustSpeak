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
            public int UserId { get; set; }
        }

        [HttpPost("generate-token")]
        public string GenerateToken([FromBody] ChannelNameRequest request)
        {
            Console.WriteLine(request.UserId);
            return _sessionService.GenerateAgoraToken(request.ChannelName, request.UserId);
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
        public async Task<TutorSessionResponse[]?> GetTutorSessions()
        {
            var sessions = await _sessionService.GetTutorSessionsAsync();

            return sessions;
        }

        [HttpGet("student")]
        public async Task<StudentSessionResponse[]> GetStudentSessions()
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
    }
}
