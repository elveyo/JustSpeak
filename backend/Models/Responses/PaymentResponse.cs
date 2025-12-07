namespace Models.Responses
{
    public class PaymentResponse
    {
        public int Id { get; set; }
        public int SessionId { get; set; }
        public string Sender { get; set; } = string.Empty;
        public string Recipient { get; set; } = string.Empty;
        public decimal Amount { get; set; }
        public string Status { get; set; } = string.Empty;
        public DateTime CreatedAt { get; set; }
    }
}
