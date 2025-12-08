using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Model.Responses;
using Model.SearchObjects;
using Models.Requests;
using Models.Responses;
using Services.Interfaces;

namespace WebAPI.Controllers
{
    [Authorize]
    public class PostController
        : BaseCRUDController<PostResponse, BaseSearchObject, PostUpsertRequest, PostUpsertRequest>
    {
        private readonly IPostService _postService;

        public PostController(IPostService service)
            : base(service)
        {
            _postService = service;
        }

        [HttpPost("{postId}/like")]
        public async Task<IActionResult> LikePost(int postId)
        {
            await _postService.LikePost(postId);
            return Ok(new { message = "Post liked successfully." });
        }

        [HttpGet("{postId}/comments")]
        public async Task<PagedResult<CommentResponse>> GetComments(
            int postId,
            [FromQuery] BaseSearchObject search
        )
        {
            return await _postService.GetCommentsForPost(postId, search);
        }

        [HttpPost("{postId}/comments")]
        public async Task<IActionResult> AddComment(
            int postId,
            [FromBody] CommentUpsertRequest request
        )
        {
            await _postService.AddCommentToPost(postId, request);
            return Ok(new { message = "Comment added successfully" });
        }
    }
}
