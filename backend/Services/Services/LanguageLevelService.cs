using Mapster;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Model.Responses;
using Model.SearchObjects;
using Models.Requests;
using Models.Responses;
using Services.Database;
using Services.Interfaces;
using Services.Services;

namespace Services.Services
{
    public class LanguageLevelService
        : BaseCRUDService<
            LanguageLevelResponse,
            BaseSearchObject,
            LanguageLevel,
            LanguageLevelUpsertRequest,
            LanguageLevelUpsertRequest
        >,
            ILanguageLevelService
    {
        private readonly ApplicationDbContext _context;

        public LanguageLevelService(ApplicationDbContext context, IMapper mapper)
            : base(context, mapper)
        {
            _context = context;
        }

        public async Task<List<LanguageLevelResponse>> GetAllLanguageLevelsAsync()
        {
            var languageLevels = await _context
                .LanguageLevels.Select(ll => new LanguageLevelResponse
                {
                    Id = ll.Id,
                    Name = ll.Name,
                    Description = ll.Description,
                    MaxPoints = ll.MaxPoints,
                })
                .ToListAsync();

            return languageLevels;
        }
    }
}
