using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Model.SearchObjects;
using Models.Requests;
using Models.Responses;
using Services.Interfaces;

namespace WebAPI.Controllers
{
    public class PaymentController
        : BaseCRUDController<
            PaymentResponse,
            PaymentSearchObject,
            PaymentInsertRequest,
            PaymentUpdateRequest
        >
    {
        private readonly IPaymentService _paymentService;

        public PaymentController(IPaymentService service)
            : base(service)
        {
            _paymentService = service;
        }

        [AllowAnonymous]
        [HttpPost("create-intent")]
        public ActionResult CreatePaymentIntent([FromBody] CreatePaymentIntent request)
        {
            try
            {
                var intent = _paymentService.CreatePaymentIntent(request);
                return Ok(
                    new { clientSecret = intent.ClientSecret, stripeTransactionId = intent.Id }
                );
            }
            catch (Exception ex)
            {
                return BadRequest(new { error = ex.Message });
            }
        }
    }
}
