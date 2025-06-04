using System.ComponentModel.DataAnnotations;

namespace Services.Database
{
    public class LanguageLevel
    {
        public int Id { get; set; }
        [Required]
        public string Name { get; set; } = string.Empty;
        [Required]
        public string Description { get; set; } = string.Empty;
        [Required]
        public int MaxPoints { get; set; }
    }
}