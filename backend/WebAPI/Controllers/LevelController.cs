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
    public class LevelController
        : BaseCRUDController<
            LevelResponse,
            LevelSearchObject,
            LevelUpsertRequest,
            LevelUpsertRequest
        >
    {
        private readonly ILevelService _levelService;

        public LevelController(ILevelService service)
            : base(service)
        {
            _levelService = service;
        }

        /*   [HttpGet("all")]
          public async Task<ActionResult<List<LanguageLevelResponse>>> GetAllLanguageLevels()
          {
              var languageLevels = await _levelService.GetAllLanguageLevelsAsync();
              return Ok(languageLevels);
          } */
    }
}
