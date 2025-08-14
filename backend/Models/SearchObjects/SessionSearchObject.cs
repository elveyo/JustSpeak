using Model.SearchObjects;

namespace Models.SearchObjects
{
    public class SessionSearchObject : BaseSearchObject
    {

        public int? LanguageId { get; set; } 
        public int? LevelId { get; set; }
        
    }
}