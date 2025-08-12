using System.ComponentModel.DataAnnotations;

namespace Services.Database
{
    public class Session
    {
        public int Id { get; set; }
        public int LanguageId { get; set; }
        public Language Language { get; set; } = null!;
        public int LevelId { get; set; }
        public LanguageLevel Level { get; set; } = null!;
        public int Duration { get; set; } //minutes

        public string ChannelName { get; set; } = String.Empty;
        public int NumOfUsers { get; set; }

        public DateTime CreatedAt { get; set; }  = DateTime.UtcNow;      
        public ICollection<Tag> Tags { get; set; } = new List<Tag>();
        
    }
}