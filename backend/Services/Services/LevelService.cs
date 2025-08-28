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
    public class LevelService
        : BaseCRUDService<
            LevelResponse,
            BaseSearchObject,
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

        public async Task<List<LevelResponse>> GetAllLanguageLevelsAsync()
        {
            var levels = await _context
                .Levels.Select(ll => new LevelResponse
                {
                    Id = ll.Id,
                    Name = ll.Name,
                    Description = ll.Description,
                    MaxPoints = ll.MaxPoints,
                })
                .ToListAsync();

            return levels;
        }
    }
}
