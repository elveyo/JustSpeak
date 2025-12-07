using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Model.Responses;
using Model.SearchObjects;
using Models.Requests;
using Models.Responses;
using Services.Database;
using Services.Interfaces;

namespace Services.Services
{
    public class CertificateService
        : BaseCRUDService<
            CertificateResponse,
            BaseSearchObject,
            Certificate,
            CertificateUpsertRequest,
            CertificateUpsertRequest
        >,
            ICertificateService
    {
        public CertificateService(ApplicationDbContext context, IMapper mapper)
            : base(context, mapper) { }

        public override async Task<PagedResult<CertificateResponse>> GetAsync(
            BaseSearchObject? search
        )
        {
            var query = _context.Certificates.Include(c => c.Language).AsQueryable();
            query = ApplyFilter(query, search);
            var totalCount = await query.CountAsync();

            query = ApplyPagination(query, search);

            var certificates = await query.ToListAsync();
            var items = certificates
                .Select(c => new CertificateResponse
                {
                    Id = c.Id,
                    Name = c.Name,
                    ImageUrl = c.ImageUrl,
                    Language = c.Language.Name,
                })
                .ToList();

            return new PagedResult<CertificateResponse> { Items = items, TotalCount = totalCount };
        }

        public override async Task<CertificateResponse?> GetByIdAsync(int id)
        {
            var certificate = await _context
                .Certificates.Include(c => c.Language)
                .FirstOrDefaultAsync(c => c.Id == id);
            if (certificate == null)
                return null;

            return new CertificateResponse
            {
                Id = certificate.Id,
                Name = certificate.Name,
                ImageUrl = certificate.ImageUrl,
                Language = certificate.Language.Name,
            };
        }
    }
}
