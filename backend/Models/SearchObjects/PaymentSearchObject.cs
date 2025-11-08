using System;

namespace Model.SearchObjects
{
    public class PaymentSearchObject : BaseSearchObject
    {
        public string? Status { get; set; }
        public DateTime? CreatedAfter { get; set; }
        public DateTime? CreatedBefore { get; set; }
        public decimal? MinAmount { get; set; }
        public decimal? MaxAmount { get; set; }
    }
}
