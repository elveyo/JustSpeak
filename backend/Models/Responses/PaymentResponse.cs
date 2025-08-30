namespace Models.Responses
{
    public class PaymentResponse
    {
        public int Id { get; set; }
        public int SessionId { get; set; }
        public decimal Amount { get; set; }
        public string Status { get; set; } = string.Empty;
        public DateTime CreatedAt { get; set; }
    }
}
