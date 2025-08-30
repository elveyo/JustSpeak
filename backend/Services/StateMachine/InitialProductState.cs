using MapsterMapper;
using Models.Requests;
using Models.Responses;
using Services.Database;

namespace Services.StateMachine
{
    public class InitialPaymentState : BasePaymentState
    {
        public InitialPaymentState(
            IServiceProvider serviceProvider,
            ApplicationDbContext context,
            IMapper mapper
        )
            : base(serviceProvider, context, mapper) { }

        public override async Task<PaymentResponse> CreateAsync(PaymentInsertRequest request)
        {
            var payment = new Payment();

            _mapper.Map(request, payment);

            payment.Status = nameof(SucceededPaymentState);

            _context.Payments.Add(payment);
            await _context.SaveChangesAsync();

            return _mapper.Map<PaymentResponse>(payment);
        }
    }
}
