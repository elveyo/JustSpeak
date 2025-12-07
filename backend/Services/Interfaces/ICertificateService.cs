using Model.SearchObjects;
using Models.Requests;
using Models.Responses;

namespace Services.Interfaces
{
    public interface ICertificateService
        : ICRUDService<
            CertificateResponse,
            BaseSearchObject,
            CertificateUpsertRequest,
            CertificateUpsertRequest
        > { }
}
