using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Models.Requests;
using Models.Responses;
using Models.SearchObjects;
using Services.Database;
using Services.Interfaces;

namespace Services.Services
{
    public class TagService
        : BaseCRUDService<TagResponse, TagSearchObject, Tag, TagUpsertRequest, TagUpsertRequest>,
            ITagService
    {
        public TagService(ApplicationDbContext context, IMapper mapper)
            : base(context, mapper) { }
    }
}
