namespace Services.Database
{
    public class StudentTutorSession
    {
        public int Id { get; set; }
        public int StudentId { get; set; }
        public Student Student { get; set; } = null!;
        public int LanguageId { get; set; }
        public Language Language { get; set; } = null!;
        public int LevelId { get; set; }
        public Level Level { get; set; } = null!;
        public int TutorId { get; set; }
        public Tutor Tutor { get; set; } = null!;
        public DateTime StartTime { get; set; }
        public DateTime EndTime { get; set; }
        public bool IsActive { get; set; } = false;
        public string? Notes { get; set; }
        public int? Rating { get; set; } = null;
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    }
}
