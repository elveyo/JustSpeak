using Microsoft.AspNetCore.Mvc;
using Services.Interfaces;
using Models.Requests;
using Models.Responses;
using Model.SearchObjects;
using Models.SearchObjects;

namespace WebAPI.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class SessionController : BaseCRUDController<SessionResponse, SessionSearchObject, SessionUpsertRequest, SessionUpsertRequest>
    {
        private readonly ISessionService _sessionService;
        private readonly IUserContextService _userContextService;

        public SessionController(ISessionService service, IUserContextService userContextService) : base(service)
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
        public string GenerateToken([FromBody] ChannelNameRequest request){
            Console.WriteLine(request.UserId);
            return _sessionService.GenerateAgoraToken(request.ChannelName,request.UserId);
        }


       

    }
} 