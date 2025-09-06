using Models.Responses;
using Models.Requests;
using Model.SearchObjects;
using Models.SearchObjects;

namespace Services.Interfaces
{
    public interface ILanguageService : ICRUDService<LanguageResponse, LanguageSearchObject, LanguageUpsertRequest, LanguageUpsertRequest>
    {
        Task<List<LanguageResponse>> GetAllLanguagesAsync();
    }
} 