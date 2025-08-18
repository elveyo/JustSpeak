using Model.Responses;
using Model.SearchObjects;

namespace Services
{
    public interface IService<T, TSearch>
        where T : class
        where TSearch : BaseSearchObject
    {
        Task<PagedResult<T>> GetAsync(TSearch? search);
        Task<T?> GetByIdAsync(int id);
    }
}
