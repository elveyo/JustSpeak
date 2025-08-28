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
            var user = await _userService.AuthenticateAsync(request);

            return Ok(user);
        }

        [HttpPost("register-tutor")]
        public async Task<IActionResult> RegisterTutor([FromBody] TutorUpsertRequest request)
        {
            var tutor = await _userService.InsertTutorDataAsync(request);
            return Ok(tutor);
        }

        [HttpPost("register-student")]
        public async Task<IActionResult> RegisterStudent([FromBody] StudentUpsertRequest request)
        {
            var student = await _userService.InsertStudentDataAsync(request);
            return Ok(student);
        }

        [HttpGet("tutor-profile/{id}")]
        public async Task<IActionResult> GetTutorProfile(int id)
        {
            var tutorProfile = await _userService.GetTutorDataAsync(id);
            if (tutorProfile == null)
                return NotFound();

            return Ok(tutorProfile);
        }

        [HttpGet("student-profile/{id}")]
        public async Task<IActionResult> GetStudentProfile(int id)
        {
            var studentProfile = await _userService.GetStudentDataAsync(id);
            if (studentProfile == null)
                return NotFound();

            return Ok(studentProfile);
        }
    }
}
