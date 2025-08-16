using Models.Responses;
using Models.Requests;
using Model.SearchObjects;

namespace Services.Interfaces
{
    public interface ILanguageLevelService : ICRUDService<LanguageLevelResponse, BaseSearchObject, LanguageLevelUpsertRequest, LanguageLevelUpsertRequest>
    {
        Task<List<LanguageLevelResponse>> GetAllLanguageLevelsAsync();
    }
} 