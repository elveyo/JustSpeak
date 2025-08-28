namespace Services.Database
{
    public class Certificate
    {
        public int Id { get; set; }
        public string Name { get; set; } = String.Empty;
        public string ImageUrl { get; set; } = String.Empty;
        public int TutorId { get; set; }
        public Tutor Tutor { get; set; } = null!;
        public int LanguageId { get; set; }
        public Language Language { get; set; } = null!;
    }
}
