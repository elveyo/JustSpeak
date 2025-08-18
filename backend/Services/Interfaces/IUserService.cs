using Models.Requests;
using Models.Responses;
using Models.SearchObjects;

namespace Services.Interfaces
{
    public interface IUserService
        : ICRUDService<UserResponse, UserSearchObject, UserInsertRequest, UserUpdateRequest>
    {
        Task<UserResponse?> AuthenticateAsync(UserLoginRequest request);
    }
}
