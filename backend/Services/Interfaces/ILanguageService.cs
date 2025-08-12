using Models.Responses;
using Models.Requests;
using Model.SearchObjects;

namespace Services.Interfaces
{
    public interface ILanguageService : ICRUDService<LanguageResponse, BaseSearchObject, LanguageUpsertRequest, LanguageUpsertRequest>
    {
        Task<List<LanguageResponse>> GetAllLanguagesAsync();
    }
} 