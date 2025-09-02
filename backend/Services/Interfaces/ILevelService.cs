using Model.SearchObjects;
using Models.Requests;
using Models.Responses;

namespace Services.Interfaces
{
    public interface ILevelService
        : ICRUDService<LevelResponse, BaseSearchObject, LevelUpsertRequest, LevelUpsertRequest> { }
}
