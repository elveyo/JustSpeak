using System;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using AgoraNET;
using Azure.Core;
using MapsterMapper;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Model.Responses;
using Model.SearchObjects;
using Models.Requests;
using Models.Responses;
using Models.SearchObjects;
using Services.Database;
using Services.Interfaces;
using Stripe;

namespace Services.Services
{
    public class SessionService
        : BaseCRUDService<
            SessionResponse,
            BaseSearchObject,
            Session,
            SessionUpsertRequest,
            SessionUpsertRequest
        >,
            ISessionService
    {
        private readonly IConfiguration _configuration;
        private readonly IUserContextService _userContextService;
        private readonly string _agoraAppId;
        private readonly string _agoraAppCertificate;
        private readonly IPaymentService _paymentService;
        private readonly IMessageBrokerService _messageBrokerService;

        public SessionService(
            ApplicationDbContext context,
            IMapper mapper,
            IConfiguration configuration,
            IUserContextService userContextService,
            IPaymentService paymentService,
            IMessageBrokerService messageBrokerService
        )
            : base(context, mapper)
        {
            _configuration = configuration;
            _agoraAppId = _configuration["Agora:AppId"] ?? "";
            _agoraAppCertificate = _configuration["Agora:AppCertificate"] ?? "";
            _userContextService = userContextService;
            _paymentService = paymentService;
            _messageBrokerService = messageBrokerService;
        }

        private int? UserId => _userContextService.GetUserId();

        public override async Task<SessionResponse> CreateAsync(SessionUpsertRequest request)
        {
            var user = await _context.Users.FirstOrDefaultAsync(u => u.Id == UserId.Value);

            var session = new Session
            {
                NumOfUsers = request.NumOfUsers,
                LanguageId = request.LanguageId,
                LevelId = request.LevelId,
                Duration = request.Duration,
                ChannelName = request.ChannelName,
                CreatedAt = DateTime.UtcNow,
            };

            _context.Sessions.Add(session);
            var tags = await _context.Tags.Where(t => request.Tags.Contains(t.Id)).ToListAsync();
            session.Tags = tags;
            await _context.SaveChangesAsync();
            await _context.Entry(session).Reference(s => s.Language).LoadAsync();
            await _context.Entry(session).Reference(s => s.Level).LoadAsync();
            var token = Get(request.ChannelName, user.FullName);
            return new SessionResponse
            {
                Id = session.Id,
                Language = session.Language.Name,
                Level = session.Level.Name,
                NumOfUsers = session.NumOfUsers,
                Duration = session.Duration,
                CreatedAt = session.CreatedAt,
                ChannelName = session.ChannelName,
                Token = token,
                Tags = session
                    .Tags.Select(tag => new TagResponse
                    {
                        Id = tag.Id,
                        Name = tag.Name,
                        Color = tag.Color,
                    })
                    .ToList(),
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
                    Tags = s
                        .Tags.Select(tag => new TagResponse
                        {
                            Id = tag.Id,
                            Name = tag.Name,
                            Color = tag.Color,
                        })
                        .ToList(),
                })
                .ToListAsync();

            return new PagedResult<SessionResponse> { Items = sessions, TotalCount = totalCount };
        }

        public async Task<int> BookSessionAsync(BookSessionRequest request)
        {
            // 1. Dohvati tutorov schedule
            var schedule = await _context
                .Schedules.Include(s => s.AvailableDays)
                .FirstOrDefaultAsync(s => s.TutorId == request.TutorId);

            if (schedule == null)
                throw new Exception("Tutor schedule not found.");

            // 2. Provjeri da li datum i vrijeme odgovara tutorovoj dostupnosti
            var dayRule = schedule.AvailableDays.FirstOrDefault(d =>
                d.DayOfWeek == request.StartTime.DayOfWeek
            );
            if (dayRule == null)
                throw new Exception("Tutor is not available on this day.");

            var duration = TimeSpan.FromMinutes(schedule.Duration);
            var endTime = request.StartTime + duration;

            var slotStartTime = dayRule.StartTime;
            var slotEndTime = dayRule.EndTime;

            if (request.StartTime.TimeOfDay < slotStartTime || endTime.TimeOfDay > slotEndTime)
                throw new Exception("Selected time is outside tutor's available hours.");

            // 3. Provjeri da li je slot već booked
            var isTaken = await _context.StudentTutorSessions.AnyAsync(s =>
                s.TutorId == request.TutorId && s.StartTime == request.StartTime
            );

            if (isTaken)
                throw new Exception("Selected slot is already booked.");

            var session = new StudentTutorSession
            {
                TutorId = request.TutorId,
                StudentId = request.StudentId,
                LanguageId = request.LanguageId,
                LevelId = request.LevelId,
                StartTime = request.StartTime,
                EndTime = endTime,
                IsActive = true,
                CreatedAt = DateTime.UtcNow,
            };

            _context.StudentTutorSessions.Add(session);
            await _context.SaveChangesAsync();

            //_messageBrokerService.Publish(session, "session-booked");
            return session.Id;
        }

        public async Task<BookedSessionResponse[]?> GetTutorSessionsAsync()
        {
            var schedule = await _context.Schedules.FirstOrDefaultAsync(s =>
                s.TutorId == UserId!.Value
            );
            if (schedule == null)
                return null;
            var bookedSessions = await _context
                .StudentTutorSessions.Where(sts => sts.TutorId == UserId!.Value)
                .Select(s => new BookedSessionResponse
                {
                    Language = s.Language.Name,
                    Level = s.Level.Name,
                    UserName = s.Student.FullName,
                    UserImageUrl = s.Student.ImageUrl,
                    Date = s.StartTime.Date,
                    StartTime = s.StartTime,
                    EndTime = s.EndTime,
                    IsActive = s.IsActive,
                })
                .ToArrayAsync();

            return bookedSessions;
        }

        public async Task<BookedSessionResponse[]> GetStudentSessionsAsync()
        {
            var bookedSessions = await _context
                .StudentTutorSessions.Where(sts => sts.StudentId == UserId!.Value)
                .Select(s => new BookedSessionResponse
                {
                    Language = s.Language.Name,
                    Level = s.Level.Name,
                    UserName = s.Tutor.FullName,
                    UserImageUrl = s.Tutor.ImageUrl,
                    Date = s.StartTime.Date,
                    StartTime = s.StartTime,
                    EndTime = s.EndTime,
                    IsActive = s.IsActive,
                })
                .ToArrayAsync();

            return bookedSessions;
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
                    Color = tag.Color,
                })
                .ToListAsync();

            return new PagedResult<TagResponse> { Items = tags, TotalCount = totalCount };
        }

        public string Get(string channelName, string userAccount)
        {
            Console.WriteLine(_agoraAppId);
            Console.WriteLine(_agoraAppCertificate);

            var role = AgoraNET.RtcUserRole.Publisher;
            var expireSeconds = 3600;
            var currentTimestamp = (int)(DateTimeOffset.UtcNow.ToUnixTimeSeconds());
            var privilegeExpiredTs = (uint)(currentTimestamp + expireSeconds);

            var token = new RtcTokenBuilder().BuildToken(
                _agoraAppId,
                _agoraAppCertificate,
                channelName,
                userAccount,
                role,
                privilegeExpiredTs
            );

            return token;
        }
    }
}
