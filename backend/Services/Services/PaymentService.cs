using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using DotNetEnv;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Model.SearchObjects;
using Models.Requests;
using Models.Responses;
using Services.Database;
using Services.Interfaces;
using Services.StateMachine;
using Stripe;

namespace Services.Services
{
    public class PaymentService
        : BaseCRUDService<
            PaymentResponse,
            BaseSearchObject,
            Payment,
            PaymentInsertRequest,
            PaymentUpdateRequest
        >,
            IPaymentService
    {
        private readonly BasePaymentState _paymentState;

        public PaymentService(
            ApplicationDbContext context,
            IMapper mapper,
            BasePaymentState paymentState
        )
            : base(context, mapper)
        {
            _paymentState = paymentState;
        }

        public override async Task<PaymentResponse> CreateAsync(PaymentInsertRequest request)
        {
            var state = _paymentState.GetPaymentState(nameof(InitialPaymentState));
            return await state.CreateAsync(request);
        }

        public PaymentIntent CreatePaymentIntent(CreatePaymentIntent request)
        {
            try
            {
                long amountInCents = (long)(request.Amount * 100);

                var options = new PaymentIntentCreateOptions
                {
                    Amount = amountInCents,
                    Currency = "eur",
                    PaymentMethodTypes = new List<string> { "card" },
                };

                var service = new PaymentIntentService();
                var intent = service.Create(options);

                return intent;
            }
            catch (StripeException ex)
            {
                throw new Exception($"Stripe payment intent creation failed: {ex.Message}", ex);
            }
            catch (Exception ex)
            {
                throw new Exception($"Payment intent creation failed: {ex.Message}", ex);
            }
        }
    }
}
