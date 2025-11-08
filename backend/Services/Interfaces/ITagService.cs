using Models.Requests;
using Models.Responses;
using Models.SearchObjects;

namespace Services.Interfaces
{
    public interface ITagService
        : ICRUDService<TagResponse, TagSearchObject, TagUpsertRequest, TagUpsertRequest> { }
}
