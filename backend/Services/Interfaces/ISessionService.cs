using Model.SearchObjects;
using Models.Requests;
using Models.Responses;
using Services.Services;

namespace Services.Interfaces
{
    public interface ISessionService : ICRUDService<SessionResponse, BaseSearchObject, SessionUpsertRequest, SessionUpsertRequest>
    {
      
        string GenerateAgoraToken(string cannelName, int userId);
    }
}