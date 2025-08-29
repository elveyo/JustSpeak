using Models.Requests;
using Models.Responses;
using Models.SearchObjects;
using Services.Database;

namespace Services.Interfaces
{
    public interface IUserService
        : ICRUDService<UserResponse, UserSearchObject, UserInsertRequest, UserUpdateRequest>
    {
        Task<UserResponse?> AuthenticateAsync(UserLoginRequest request);

        Task<TutorResponse?> GetTutorDataAsync(int id);
        Task<StudentResponse?> GetStudentDataAsync(int id);
    }
}
