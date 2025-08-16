namespace Services.Database
{
    public class Certificate
    {
        public int Id { get; set; }
        public string Name { get; set; } = String.Empty;
        public String ImageUrl { get; set; } = String.Empty;
        public int TutorId { get; set; }
        public Tutor Tutor { get; set; } = null!;
    }
}


