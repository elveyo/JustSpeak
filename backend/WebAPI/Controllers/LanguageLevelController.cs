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
    public class LanguageLevelController : BaseCRUDController<LanguageLevelResponse, BaseSearchObject, LanguageLevelUpsertRequest, LanguageLevelUpsertRequest>
    {
        private readonly ILanguageLevelService _languageLevelService;
        
        public LanguageLevelController(ILanguageLevelService service) : base(service)
        {
            _languageLevelService = service;
        }

        [HttpGet("all")]
        public async Task<ActionResult<List<LanguageLevelResponse>>> GetAllLanguageLevels()
        {
            var languageLevels = await _languageLevelService.GetAllLanguageLevelsAsync();
            return Ok(languageLevels);
        }
    }
} 