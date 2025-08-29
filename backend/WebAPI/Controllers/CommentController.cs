using Model.SearchObjects;
using Models.Requests;
using Models.Responses;
using Services.Interfaces;

namespace WebAPI.Controllers
{
    public class CommentController
        : BaseCRUDController<
            CommentResponse,
            BaseSearchObject,
            CommentUpsertRequest,
            CommentUpsertRequest
        >
    {
        public CommentController(ICommentService service)
            : base(service) { }
    }
}
