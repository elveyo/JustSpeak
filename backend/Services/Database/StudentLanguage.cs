namespace Services.Database
{
    public class StudentLanguage
    {
        public int Id { get; set; }
        public int StudentId { get; set; }
        public Student Student { get; set; } = null!;
        public int LanguageId { get; set; }
        public Language Language { get; set; } = null!;
        public int LevelId { get; set; }
        public Level Level { get; set; } = null!;
        public int Points { get; set; }
        public DateTime DateAdded { get; set; } = DateTime.UtcNow;
    }
}
