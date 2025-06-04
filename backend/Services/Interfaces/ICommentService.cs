using Model.SearchObjects;
using Models.Requests;
using Models.Responses;

namespace Services.Interfaces
{
    public interface ICommentService : ICRUDService<CommentResponse, BaseSearchObject, CommentUpsertRequest, CommentUpsertRequest>
    {
         
    }
}