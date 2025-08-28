using Model.Responses;
using Model.SearchObjects;
using Models.Requests;
using Models.Responses;

namespace Services.Interfaces
{
    public interface IPostService
        : ICRUDService<PostResponse, BaseSearchObject, PostUpsertRequest, PostUpsertRequest>
    {
        Task LikePost(int postId);
        Task AddCommentToPost(int postId, CommentUpsertRequest request);
        Task<PagedResult<CommentResponse>> GetCommentsForPost(int postId, BaseSearchObject search);
    }
}
