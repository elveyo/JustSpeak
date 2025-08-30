using System.ComponentModel.DataAnnotations;

namespace Models.Requests
{
    public class PaymentInsertRequest
    {
        public int SessionId { get; set; }

        public decimal Amount { get; set; }

        public string Status { get; set; } = string.Empty;

        public string StripeTransactionId { get; set; } = null!;
    }
}
