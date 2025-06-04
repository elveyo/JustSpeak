namespace Services.Database
{
    public class TutorLanguage
    {
        public int Id { get; set; }
        public int TutorId { get; set; }
        public Tutor Tutor { get; set; } = null!;
        public int LanguageId { get; set; }
        public Language Language { get; set; } = null!;
        public int LevelId { get; set; }
        public LanguageLevel Level { get; set; } = null!;
        public int Experience { get; set; }
        public int PricePerHour { get; set; }
    }
}