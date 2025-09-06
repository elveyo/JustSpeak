using Mapster;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Model.Responses;
using Model.SearchObjects;
using Models.Requests;
using Models.Responses;
using Services.Database;
using Services.Interfaces;
using Services.Recommender;
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
        private readonly IRecommenderService _recommender;

        public PostService(
            ApplicationDbContext context,
            IMapper mapper,
            IUserContextService userContextService,
            IRecommenderService recommender
        )
            : base(context, mapper)
        {
            _context = context;
            _userContextService = userContextService;
            _recommender = recommender;
        }

        public override async Task<PagedResult<PostResponse>> GetAsync(BaseSearchObject search)
        {
            int? userId = _userContextService.GetUserId();
            var query = _context
                .Posts.Include(p => p.Author)
                .ThenInclude(a => a.Role)
                .Include(p => p.Likes)
                .Include(p => p.Comments)
                .Where(p => p.AuthorId != userId.Value)
                .AsQueryable();

            var totalCount = await query.CountAsync();

            query = ApplyPagination(query, search);
            var posts = await query.ToListAsync();
            var finalFeed = posts;
            if (search.Page == 0 && userId.HasValue)
            {
                var recommendedPosts = await _recommender.GetTopPostsForUserAsync(userId.Value, 10);
                var recommendedIds = recommendedPosts.Select(p => p.Id).ToHashSet();
                int remaining = search.PageSize.Value - recommendedPosts.Count;
                posts = posts
                    .Where(p => !recommendedIds.Contains(p.Id))
                    .Take(remaining)
                    .ToList();
                finalFeed = recommendedPosts.Concat(posts).ToList();
            }

            var postResponses = finalFeed
                .Select(post => new PostResponse
                {
                    Id = post.Id,
                    Content = post.Content,
                    AuthorId = post.AuthorId,
                    AuthorName = post.Author?.FullName ?? "",
                    UserRole = post.Author?.Role.Name ?? "",
                    ImageUrl = post.ImageUrl,
                    NumOfLikes = post.Likes.Count,
                    NumOfComments = post.Comments.Count,
                    CreatedAt = post.CreatedAt,
                    LikedByCurrUser = userId != null && post.Likes.Any(l => l.UserId == userId),
                })
                .ToList();

            return new PagedResult<PostResponse>
            {
                Items = postResponses,
                TotalCount = totalCount,
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
