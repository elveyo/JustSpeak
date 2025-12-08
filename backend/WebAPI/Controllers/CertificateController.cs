using Microsoft.AspNetCore.Mvc;
using Model.Responses;
using Model.SearchObjects;
using Models.Requests;
using Models.Responses;
using Services.Interfaces;

using Microsoft.AspNetCore.Authorization;

namespace WebAPI.Controllers
{
    [Authorize]
    public class CertificateController
        : BaseCRUDController<
            CertificateResponse,
            BaseSearchObject,
            CertificateUpsertRequest,
            CertificateUpsertRequest
        >
    {
        private readonly ICertificateService _certificateService;

        public CertificateController(ICertificateService service)
            : base(service)
        {
            _certificateService = service;
        }
    }
}
