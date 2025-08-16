using Microsoft.EntityFrameworkCore;
using Services.Database;
using Services.Interfaces;
using Models.Requests;
using Models.Responses;
using Model.SearchObjects;
using MapsterMapper;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System;
using Microsoft.Extensions.Configuration;
using Microsoft.AspNetCore.Http;
using Model.Responses;
using AgoraNET;
using Models.SearchObjects;


namespace Services.Services
{
    public class SessionService : BaseCRUDService<SessionResponse, BaseSearchObject, Session, SessionUpsertRequest, SessionUpsertRequest>, ISessionService
    {
        private readonly IConfiguration _configuration;
        private readonly IUserContextService _userContextService;
        private readonly string _agoraAppId;
        private readonly string _agoraAppCertificate;

        public SessionService(ApplicationDbContext context, IMapper mapper, IConfiguration configuration, IUserContextService userContextService) : base(context, mapper)
        {
            _configuration = configuration;
            _agoraAppId = _configuration["Agora:AppId"] ?? "";
            _agoraAppCertificate = _configuration["Agora:AppCertificate"] ?? "";
            _userContextService = userContextService;
        }


        public override async Task<SessionResponse> CreateAsync(SessionUpsertRequest request)
        {
            //int? currentUserId = _userContextService.GetUserId();
            var session = new Session
            {
                NumOfUsers = request.NumOfUsers,
                LanguageId = request.LanguageId,
                LevelId = request.LevelId,
                Duration = request.Duration,
                ChannelName = request.ChannelName,
                CreatedAt = DateTime.UtcNow
            };

            _context.Sessions.Add(session);
            var tags = await _context.Tags
                .Where(t => request.Tags.Contains(t.Id))
                .ToListAsync();
            session.Tags = tags;
            await _context.SaveChangesAsync();
           await _context.Entry(session).Reference(s => s.Language).LoadAsync();
           await _context.Entry(session).Reference(s => s.Level).LoadAsync();
            return new SessionResponse
            {
                Id = session.Id,
                Language = session.Language.Name,
                Level = session.Level.Name,
                NumOfUsers = session.NumOfUsers,
                Duration = session.Duration,
                CreatedAt = session.CreatedAt,
                ChannelName = session.ChannelName,
                Token = "agoraToken",
                Tags = session.Tags.Select(tag => new TagResponse
                {
                    Id = tag.Id,
                    Name = tag.Name,
                    Color = tag.Color
                }).ToList()
            };
        }

        public async Task<PagedResult<SessionResponse>> GetAsync(SessionSearchObject search)
        {
            // Create query
            var query = _context.Sessions.AsQueryable();

            // Apply search filters if items exist
            if (search.LanguageId.HasValue)
            {
                query = query.Where(s => s.LanguageId == search.LanguageId.Value);
            }
            if (search.LevelId.HasValue)
            {
                query = query.Where(s => s.LevelId == search.LevelId.Value);
            }

            var totalCount = await query.CountAsync();

            var sessions = await query
                .Skip((search.Page ?? 0) * (search.PageSize ?? 10))
                .Take(search.PageSize ?? 10)
                .Select(s => new SessionResponse
                {
                    Id = s.Id,
                    Language = s.Language.Name,
                    Level = s.Level.Name,
                    NumOfUsers = s.NumOfUsers,
                    Duration = s.Duration,
                    CreatedAt = s.CreatedAt,
                    ChannelName = s.ChannelName,
                           Tags = s.Tags.Select(tag => new TagResponse
                {
                    Id = tag.Id,
                    Name = tag.Name,
                    Color = tag.Color
                }).ToList()
                }).ToListAsync();

            return new PagedResult<SessionResponse>
            {
                Items = sessions,
                TotalCount = totalCount
            };
        }

    
        



public string GenerateAgoraToken(string channelName, int userId)
{


    var token = new RtcTokenBuilder();
    // Set expireTime to one day (24 hours) from now as an absolute Unix timestamp
    uint oneDayExpireTime = (uint)(DateTimeOffset.UtcNow.ToUnixTimeSeconds() + 24 * 60 * 60);
    return token.BuildToken(_agoraAppId, _agoraAppCertificate, channelName, (uint)userId, AgoraNET.RtcUserRole.Publisher, oneDayExpireTime);
}



public async Task<PagedResult<TagResponse>> GetTagsAsync(BaseSearchObject query)
        {
 var tagsQuery = _context.Tags.AsQueryable();

            int page = query.Page ?? 0;
            int pageSize = query.PageSize ?? 10;

            var totalCount = await tagsQuery.CountAsync();

            var tags = await tagsQuery
                .Skip(page * pageSize)
                .Take(pageSize)
                .Select(tag => new TagResponse
                {
                    Id = tag.Id,
                    Name = tag.Name,
                    Color = tag.Color
                })
                .ToListAsync();

            return new PagedResult<TagResponse>
            {
                Items = tags,
                TotalCount = totalCount
            };       
             }
    }

    // Agora Token Builder Implementation
    public class AgoraTokenBuilder
    {
        public const int PrivilegeJoinChannel = 1;
        public const int PrivilegePublishAudioStream = 2;
        public const int PrivilegePublishVideoStream = 3;
        public const int PrivilegePublishDataStream = 4;
        public const int PrivilegeManageChannel = 5;

        private readonly string _appId;
        private readonly string _appCertificate;
        private readonly string _channelName;
        private readonly uint _uid;
        private readonly Dictionary<int, uint> _privileges;

        public AgoraTokenBuilder(string appId, string appCertificate, string channelName, uint uid)
        {
            _appId = appId;
            _appCertificate = appCertificate;
            _channelName = channelName;
            _uid = uid;
            _privileges = new Dictionary<int, uint>();
        }

        public void AddPrivilege(int privilege, uint expireTimestamp)
        {
            _privileges[privilege] = expireTimestamp;
        }

        public string Build()
        {
            var message = new
            {
                appid = _appId,
                channel = _channelName,
                uid = _uid,
                privileges = _privileges
            };

            var messageJson = System.Text.Json.JsonSerializer.Serialize(message);
            var messageBytes = Encoding.UTF8.GetBytes(messageJson);
            var messageBase64 = Convert.ToBase64String(messageBytes);

            // Create signature
            var signature = CreateSignature(messageBase64);
            var signatureBase64 = Convert.ToBase64String(signature);

            // Build token
            return $"{messageBase64}.{signatureBase64}";
        }

        private byte[] CreateSignature(string message)
        {
            using var hmac = new HMACSHA256(Encoding.UTF8.GetBytes(_appCertificate));
            return hmac.ComputeHash(Encoding.UTF8.GetBytes(message));
        }
    }

   
} 