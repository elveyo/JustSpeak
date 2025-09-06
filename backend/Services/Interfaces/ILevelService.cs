using Model.SearchObjects;
using Models.Requests;
using Models.Responses;
using Models.SearchObjects;

namespace Services.Interfaces
{
    public interface ILevelService
        : ICRUDService<LevelResponse, LevelSearchObject, LevelUpsertRequest, LevelUpsertRequest> { }
}
