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
    }
}
