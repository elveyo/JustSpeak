namespace Services.Database
{
    public class Payment
    {
        public int Id { get; set; }
        public int StudentId { get; set; }
        public Student Student { get; set; } = null!;
        public int TutorId { get; set; }
        public Tutor Tutor { get; set; } = null!;
        public int SessionId { get; set; }
        public StudentTutorSession Session { get; set; } = null!;
        public decimal Amount { get; set; }
        public string PaymentStatus { get; set; } = null!;
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    }
}
