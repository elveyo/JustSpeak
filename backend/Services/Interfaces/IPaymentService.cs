using Model.SearchObjects;
using Models.Requests;
using Models.Responses;
using Stripe;

namespace Services.Interfaces
{
    public interface IPaymentService
        : ICRUDService<
            PaymentResponse,
            PaymentSearchObject,
            PaymentInsertRequest,
            PaymentUpdateRequest
        >
    {
        PaymentIntent CreatePaymentIntent(CreatePaymentIntent request);
    }
}
