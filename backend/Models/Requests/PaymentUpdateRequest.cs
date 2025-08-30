using System.ComponentModel.DataAnnotations;

namespace Models.Requests
{
    public class PaymentUpdateRequest
    {
        public string Id { get; set; } = null!;
        public string PaymentMethod { get; set; } = null!;
    }
}
