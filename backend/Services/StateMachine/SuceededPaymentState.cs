using MapsterMapper;
using Models.Exceptions;
using Models.Responses;
using Services.Database;

namespace Services.StateMachine
{
    public class SucceededPaymentState : BasePaymentState
    {
        public SucceededPaymentState(IServiceProvider sp, ApplicationDbContext ctx, IMapper mapper)
            : base(sp, ctx, mapper) { }

        public override Task<PaymentResponse> MarkSucceededAsync(int id) =>
            throw new UserException("Payment already succeeded");

        public override Task<PaymentResponse> MarkFailedAsync(int id) =>
            throw new UserException("Payment already succeeded");

        public override Task<PaymentResponse> CancelAsync(int id) =>
            throw new UserException("Payment already succeeded");
    }
}
