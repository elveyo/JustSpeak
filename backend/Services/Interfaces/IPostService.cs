using Model.SearchObjects;
using Models.Requests;
using Models.Responses;

namespace Services.Interfaces
{
    public interface IPostService
        : ICRUDService<PostResponse, BaseSearchObject, PostUpsertRequest, PostUpsertRequest>
    {
        Task LikePost(int postId);
    }
}
