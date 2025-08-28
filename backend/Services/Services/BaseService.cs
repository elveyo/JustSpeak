using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Model.Responses;
using Model.SearchObjects;
using Services.Database;
using Services.Interfaces;

namespace Services.Services
{
    public abstract class BaseService<T, TSearch, TEntity> : IService<T, TSearch>
        where T : class
        where TSearch : BaseSearchObject
        where TEntity : class
    {
        private readonly ApplicationDbContext _context;
        protected readonly IMapper _mapper;

        public BaseService(ApplicationDbContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
        }

        public virtual async Task<PagedResult<T>> GetAsync(TSearch? search)
        {
            var query = _context.Set<TEntity>().AsQueryable();
            query = ApplyFilter(query, search);

            query = ApplyPagination(query, search);

            var list = await query.ToListAsync();
            return new PagedResult<T>
            {
                Items = list.Select(MapToResponse).ToList(),
                TotalCount = await query.CountAsync(),
            };
        }

        protected IQueryable<TEntity> ApplyPagination(IQueryable<TEntity> query, TSearch search)
        {
            if (search.Page.HasValue)
            {
                query = query.Skip(search.Page.Value * search.PageSize.Value);
            }
            if (search.PageSize.HasValue)
            {
                query = query.Take(search.PageSize.Value);
            }

            return query;
        }

        protected virtual IQueryable<TEntity> ApplyFilter(IQueryable<TEntity> query, TSearch search)
        {
            return query;
        }

        public virtual async Task<T?> GetByIdAsync(int id)
        {
            var entity = await _context.Set<TEntity>().FindAsync(id);
            if (entity == null)
                return null;

            return MapToResponse(entity);
        }

        protected virtual T MapToResponse(TEntity entity)
        {
            return _mapper.Map<T>(entity);
        }
    }
}
