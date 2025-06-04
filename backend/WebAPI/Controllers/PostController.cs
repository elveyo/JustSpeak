using Model.SearchObjects;
using Models.Requests;
using Models.Responses;
using Services.Interfaces;

namespace WebAPI.Controllers
{
    public class PostController : BaseCRUDController<PostResponse, BaseSearchObject, PostUpsertRequest, PostUpsertRequest>
    {
        public PostController(IPostService service) : base(service)
        {
        }
    }
}