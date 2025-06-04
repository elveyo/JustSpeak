using MapsterMapper;
using Model.SearchObjects;
using Models.Requests;
using Models.Responses;
using Services.Database;
using Services.Interfaces;

namespace Services.Services
{
    public class CommentService : BaseCRUDService<CommentResponse, BaseSearchObject, Comment, CommentUpsertRequest, CommentUpsertRequest>, ICommentService
    {
        public CommentService(ApplicationDbContext context, IMapper mapper) : base(context, mapper){}
    }
}