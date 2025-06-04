using System.ComponentModel.DataAnnotations;

namespace Services.Database
{
    public class Session
    {
        public int Id { get; set; }
        public int NumberOfUsers { get; set; }
        public int LanguageId { get; set; }
        public Language Language { get; set; } = null!;
        public int LevelId { get; set; }
        public LanguageLevel Level { get; set; } = null!;
        public int Duration { get; set; }
        public DateTime CreatedAt { get; set; }
        [MaxLength(100)]
        public string Description { get; set; } = string.Empty;
        //mozda dodat ownerId, kako bi se znalo ko je kreirao sesiju
        
    }
}