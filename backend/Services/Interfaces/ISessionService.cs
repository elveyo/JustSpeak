using Microsoft.EntityFrameworkCore.Metadata.Conventions;
using Model.Responses;
using Model.SearchObjects;
using Models.Requests;
using Models.Responses;
using Models.SearchObjects;
using Services.Database;
using Services.Services;

namespace Services.Interfaces
{
    public interface ISessionService
        : ICRUDService<
            SessionResponse,
            SessionSearchObject,
            SessionUpsertRequest,
            SessionUpsertRequest
        >
    {
        string GenerateAgoraToken(string channelName, int userId);
        Task<PagedResult<TagResponse>> GetTagsAsync(BaseSearchObject query);
        Task<int> BookSessionAsync(BookSessionRequest request);
        Task<BookedSessionResponse[]?> GetTutorSessionsAsync();
        Task<BookedSessionResponse[]> GetStudentSessionsAsync();
    }
}
