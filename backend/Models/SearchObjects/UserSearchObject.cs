using Model.SearchObjects;

namespace Models.SearchObjects
{
    public class UserSearchObject : BaseSearchObject
    {
        public string? Email { get; set; }
        public int? LanguageId { get; set; }
        public int? LevelId { get; set; }
        public string? Role { get; set; }
    }
}
