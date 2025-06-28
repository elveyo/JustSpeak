using MapsterMapper;
using Model.Responses;
using Model.SearchObjects;
using Models.Requests;
using Models.Responses;
using Services.Database;
using Services.Interfaces;
using Services.Services;
using Microsoft.EntityFrameworkCore;
using Mapster;

namespace Services.Services
{
    public class PostService : BaseCRUDService<PostResponse, BaseSearchObject, Post, PostUpsertRequest, PostUpsertRequest>, IPostService
    {
        private readonly ApplicationDbContext _context;
        public PostService(ApplicationDbContext context, IMapper mapper) : base(context, mapper){
            _context = context;
        }

       public override async Task<PagedResult<PostResponse>> GetAsync(BaseSearchObject search)
        {
            var query =  _context.Posts.AsQueryable();
            query = ApplyPagination(query, search);
            
             var posts = await query.Select(post=> new PostResponse{
                Id = post.Id,
                Title = post.Title,
                Content = post.Content,
                AuthorId = post.Author.Id,
                AuthorName = post.Author.FullName
            }).ToListAsync();

            return new PagedResult<PostResponse>
            {
                Items = posts,
                TotalCount = posts.Count
            };
        } 
    }
}