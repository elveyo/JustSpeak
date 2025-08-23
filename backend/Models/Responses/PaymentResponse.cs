namespace Models.Responses
{
    public class PaymentResponse
    {
        public int Id { get; set; }
        public int StudentId { get; set; }
        public string StudentName { get; set; } = null!;
        public int TutorId { get; set; }
        public string TutorName { get; set; } = null!;
        public int SessionId { get; set; }
        public decimal Amount { get; set; }
        public string PaymentStatus { get; set; } = null!;
        public DateTime CreatedAt { get; set; }
    }
}
