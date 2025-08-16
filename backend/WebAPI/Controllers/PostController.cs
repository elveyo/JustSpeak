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
    [ApiController]
    [Route("[controller]")]
    public class PostController : BaseCRUDController<PostResponse, BaseSearchObject, PostUpsertRequest, PostUpsertRequest>
    {
        private readonly IPostService _postService;
        public PostController(IPostService service) : base(service)
        {
            _postService = service;
        }

    
        [HttpPost("{postId}/like")]
        public async Task<IActionResult> LikePost(int postId)
        {
            await _postService.LikePost(postId);
            return Ok(new { message = "Post liked successfully." });
        }

        
    }
}