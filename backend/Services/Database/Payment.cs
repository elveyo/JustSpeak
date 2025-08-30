namespace Services.Database
{
    public class Payment
    {
        public int Id { get; set; }

        public int SessionId { get; set; }
        public StudentTutorSession Session { get; set; } = null!;
        public decimal Amount { get; set; }
        public string Status { get; set; } = null!;
        public string StripeTransactionId { get; set; } = null!;
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    }
}
