using Mapster;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Model.Responses;
using Model.SearchObjects;
using Models.Requests;
using Models.Responses;
using Models.SearchObjects;
using Services.Database;
using Services.Interfaces;
using Services.Services;

namespace Services.Services
{
    public class LevelService
        : BaseCRUDService<
            LevelResponse,
            LevelSearchObject,
            Level,
            LevelUpsertRequest,
            LevelUpsertRequest
        >,
            ILevelService
    {
        private readonly ApplicationDbContext _context;

        public LevelService(ApplicationDbContext context, IMapper mapper)
            : base(context, mapper)
        {
            _context = context;
        }

        public override async Task<PagedResult<LevelResponse>> GetAsync(LevelSearchObject? search)
        {
            if (search == null || !search.UserId.HasValue)
            {
                return await base.GetAsync(search);
            }
            var user = await _context
                .Users.Include(user => user.Role)
                .FirstOrDefaultAsync(u => u.Id == search.UserId.Value);
            var levels = new List<LevelResponse>();
            if (user.Role?.Name == "Student")
            {
                var studentLanguages = await _context
                    .StudentLanguages.Include(sl => sl.Level)
                    .Where(sl => sl.StudentId == user.Id && sl.LanguageId == search.LanguageId)
                    .ToListAsync();

                levels = studentLanguages
                    .SelectMany(sl =>
                        _context
                            .Levels.Where(l => l.Order <= sl.Level.Order)
                            .Select(l => new LevelResponse
                            {
                                Id = l.Id,
                                Name = l.Name,
                                Order = l.Order,
                            })
                    )
                    .ToList();
            }
            else
            {
                var tutorLanguages = await _context
                    .TutorLanguages.Include(tl => tl.Level)
                    .Where(tl => tl.TutorId == user.Id && tl.LanguageId == search.LanguageId)
                    .ToListAsync();

                levels = tutorLanguages
                    .SelectMany(tl =>
                        _context
                            .Levels.Where(l => l.Order <= tl.Level.Order)
                            .Select(l => new LevelResponse
                            {
                                Id = l.Id,
                                Name = l.Name,
                                Order = l.Order,
                            })
                    )
                    .ToList();
            }

            return new PagedResult<LevelResponse> { Items = levels, TotalCount = levels.Count };
        }
    }
}
