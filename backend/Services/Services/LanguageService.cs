using MapsterMapper;
using Model.Responses;
using Model.SearchObjects;
using Models.Responses;
using Services.Database;
using Services.Interfaces;
using Services.Services;
using Microsoft.EntityFrameworkCore;
using Mapster;
using Models.Requests;

namespace Services.Services
{
    public class LanguageService : BaseCRUDService<LanguageResponse, BaseSearchObject, Language, LanguageUpsertRequest, LanguageUpsertRequest>, ILanguageService
    {
        private readonly ApplicationDbContext _context;

        public LanguageService(ApplicationDbContext context, IMapper mapper) : base(context, mapper)
        {
            _context = context;
        }

     public async Task<List<LanguageResponse>> GetAllLanguagesAsync()
        {
            var languages = await _context.Languages
                .Select(l => new LanguageResponse
                {
                    Id = l.Id,
                    Name = l.Name
                })
                .ToListAsync();

            return languages;
        }
    }
} 