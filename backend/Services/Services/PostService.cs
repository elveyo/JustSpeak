using Mapster;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Model.Responses;
using Model.SearchObjects;
using Models.Requests;
using Models.Responses;
using Services.Database;
using Services.Interfaces;
using Services.Services;

namespace Services.Services
{
    public class PostService
        : BaseCRUDService<
            PostResponse,
            BaseSearchObject,
            Post,
            PostUpsertRequest,
            PostUpsertRequest
        >,
            IPostService
    {
        private readonly ApplicationDbContext _context;
        private readonly IUserContextService _userContextService;

        public PostService(
            ApplicationDbContext context,
            IMapper mapper,
            IUserContextService userContextService
        )
            : base(context, mapper)
        {
            _context = context;
            _userContextService = userContextService;
        }

        public override async Task<PagedResult<PostResponse>> GetAsync(BaseSearchObject search)
        {
            int? currentUserId = _userContextService.GetUserId();
            var query = _context
                .Posts.Include(p => p.Author)
                .ThenInclude(a => a.Role)
                .Include(p => p.Likes)
                .Include(p => p.Comments)
                .AsQueryable();

            query = ApplyPagination(query, search);

            var posts = await query.ToListAsync();

            var postResponses = posts
                .Select(post => new PostResponse
                {
                    Id = post.Id,
                    Content = post.Content,
                    AuthorId = post.Author.Id,
                    AuthorName = post.Author.FullName,
                    UserRole = post.Author.Role.Name,
                    ImageUrl = post.ImageUrl,
                    NumOfLikes = post.Likes.Count,
                    NumOfComments = post.Comments.Count,
                    LikedByCurrUser =
                        currentUserId != null && post.Likes.Any(l => l.UserId == currentUserId),
                })
                .ToList();

            return new PagedResult<PostResponse>
            {
                Items = postResponses,
                TotalCount = postResponses.Count,
            };
        }

        public async Task LikePost(int postId)
        {
            int? currentUserId = _userContextService.GetUserId();
            var like = await _context.Likes.FirstOrDefaultAsync(like =>
                like.PostId == postId && like.UserId == currentUserId!.Value
            );
            if (like != null)
            {
                _context.Likes.Remove(like);
                await _context.SaveChangesAsync();
                return;
            }
            var newLike = new Like { UserId = currentUserId!.Value, PostId = postId };
            await _context.Likes.AddAsync(newLike);
            await _context.SaveChangesAsync();
        }

        public async Task AddCommentToPost(int postId, CommentUpsertRequest request)
        {
            //int? currentUserId = _userContextService.GetUserId();

            var post = await _context.Posts.FindAsync(postId);
            if (post == null)
                throw new Exception("Post not found.");

            var comment = new Comment
            {
                Content = request.Content,
                CreatedAt = DateTime.UtcNow,
                AuthorId = 1,
                PostId = postId,
            };

            await _context.Comments.AddAsync(comment);
            await _context.SaveChangesAsync();
        }

        public async Task<PagedResult<CommentResponse>> GetCommentsForPost(
            int postId,
            BaseSearchObject search
        )
        {
            var query = _context
                .Comments.Where(c => c.PostId == postId)
                .OrderByDescending(c => c.CreatedAt)
                .AsQueryable();

            int page = search.Page ?? 0;
            int pageSize = search.PageSize ?? 10;
            int skip = page * pageSize;

            var totalCount = await query.CountAsync();

            var comments = await query
                .Skip(skip)
                .Take(pageSize)
                .Select(c => new CommentResponse
                {
                    Id = c.Id,
                    Content = c.Content,
                    CreatedAt = c.CreatedAt,
                    AuthorId = c.AuthorId,
                    AuthorName = c.Author.FullName,
                })
                .ToListAsync();

            return new PagedResult<CommentResponse> { Items = comments, TotalCount = totalCount };
        }
    }
}
