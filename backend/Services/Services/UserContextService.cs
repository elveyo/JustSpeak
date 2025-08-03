using System.Security.Claims;
using Services.Interfaces;
using Microsoft.AspNetCore.Http;


namespace Services
{
   public class UserContextService : IUserContextService
{
    private readonly IHttpContextAccessor _httpContextAccessor;

    public UserContextService(IHttpContextAccessor httpContextAccessor)
    {
        _httpContextAccessor = httpContextAccessor;
    }

    public int? GetUserId()
    {
        var claim = _httpContextAccessor.HttpContext?.User.FindFirst(ClaimTypes.NameIdentifier);
        if (claim == null)
        return null;

        return int.TryParse(claim.Value, out var id) ? id : null;    }
    }

}