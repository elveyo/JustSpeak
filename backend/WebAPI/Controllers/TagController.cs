using Microsoft.AspNetCore.Mvc;
using Models.Requests;
using Models.Responses;
using Models.SearchObjects;
using Services.Interfaces;

namespace WebAPI.Controllers
{
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
