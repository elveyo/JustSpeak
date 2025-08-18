using Microsoft.AspNetCore.Mvc;
using Models.Requests;
using Models.Responses;
using Models.SearchObjects;
using Services;
using Services.Database;
using Services.Interfaces;

namespace WebAPI.Controllers
{
    public class UserController
        : BaseCRUDController<UserResponse, UserSearchObject, UserInsertRequest, UserUpdateRequest>
    {
        private readonly IUserService _userService;

        public UserController(IUserService service)
            : base(service)
        {
            _userService = service;
        }

        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] UserLoginRequest request)
        {
            try
            {
                var user = await _userService.AuthenticateAsync(request);
                if (user == null)
                    return Unauthorized();
                return Ok(user);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [HttpPost("register")]
        public async Task<IActionResult> Register([FromBody] UserInsertRequest request)
        {
            try
            {
                var user = await _userService.CreateAsync(request);
                return Ok(user);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }
    }
}
