using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Model.Responses;
using Model.SearchObjects;
using Models.Requests;
using Models.Responses;
using Models.SearchObjects;
using Services.Interfaces;

namespace WebAPI.Controllers
{
    [Authorize]
    public class LanguageController
        : BaseCRUDController<
            LanguageResponse,
            LanguageSearchObject,
            LanguageUpsertRequest,
            LanguageUpsertRequest
        >
    {
        private readonly ILanguageService _languageService;

        public LanguageController(ILanguageService service)
            : base(service)
        {
            _languageService = service;
        }

        [AllowAnonymous]
        public override async Task<PagedResult<LanguageResponse>> Get([FromQuery] LanguageSearchObject? search = null)
        {
            return await base.Get(search);
        }

        [HttpGet("all")]
        public async Task<ActionResult<List<LanguageResponse>>> GetAllLanguages()
        {
            var languages = await _languageService.GetAllLanguagesAsync();
            return Ok(languages);
        }
    }
}
