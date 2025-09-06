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
    public class LanguageService
        : BaseCRUDService<
            LanguageResponse,
            LanguageSearchObject,
            Language,
            LanguageUpsertRequest,
            LanguageUpsertRequest
        >,
            ILanguageService
    {
        private readonly ApplicationDbContext _context;
        private readonly IUserContextService _userContextService;

        public LanguageService(
            ApplicationDbContext context,
            IMapper mapper,
            IUserContextService userContextService
        )
            : base(context, mapper)
        {
            _context = context;
            _userContextService = userContextService;
        }

        public override async Task<PagedResult<LanguageResponse>> GetAsync(
            LanguageSearchObject? search
        )
        {
            if (search == null || !search.UserId.HasValue)
            {
                return await base.GetAsync(search);
            }
            var user = await _context
                .Users.Include(user => user.Role)
                .FirstOrDefaultAsync(u => u.Id == search.UserId.Value);

            if (user == null)
                throw new Exception("User not found");
            var languages = new List<LanguageResponse>();
            if (user.Role?.Name == "Student")
            {
                languages = await _context
                    .StudentLanguages.Where(sl => sl.StudentId == search.UserId)
                    .Include(sl => sl.Language)
                    .Select(l => new LanguageResponse { Id = l.LanguageId, Name = l.Language.Name })
                    .ToListAsync();
            }
            else
            {
                languages = await _context
                    .TutorLanguages.Where(sl => sl.TutorId == search.UserId)
                    .Include(sl => sl.Language)
                    .Select(l => new LanguageResponse { Id = l.LanguageId, Name = l.Language.Name })
                    .ToListAsync();
            }

            return new PagedResult<LanguageResponse>
            {
                Items = languages,
                TotalCount = languages.Count,
            };
        }

        public async Task<List<LanguageResponse>> GetAllLanguagesAsync()
        {
            var languages = await _context
                .Languages.Select(l => new LanguageResponse { Id = l.Id, Name = l.Name })
                .ToListAsync();

            return languages;
        }
    }
}
