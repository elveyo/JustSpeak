using Microsoft.AspNetCore.Mvc;
using Models.Requests;
using Models.Responses;
using Models.SearchObjects;
using Services.Interfaces;

using Microsoft.AspNetCore.Authorization;

namespace WebAPI.Controllers
{
    [Authorize]
    public class TagController
        : BaseCRUDController<TagResponse, TagSearchObject, TagUpsertRequest, TagUpsertRequest>
    {
        private readonly ITagService _tagService;

        public TagController(ITagService service)
            : base(service)
        {
            _tagService = service;
        }
    }
}
