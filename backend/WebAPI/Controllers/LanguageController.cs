using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Model.Responses;
using Model.SearchObjects;
using Models.Requests;
using Models.Responses;
using Services.Interfaces;

namespace WebAPI.Controllers
{
    public class LanguageController
        : BaseCRUDController<
            LanguageResponse,
            BaseSearchObject,
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

        [HttpGet("all")]
        public async Task<ActionResult<List<LanguageResponse>>> GetAllLanguages()
        {
            var languages = await _languageService.GetAllLanguagesAsync();
            return Ok(languages);
        }
    }
}
