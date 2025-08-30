using MapsterMapper;
using Services.Database;

namespace Services.StateMachine
{
    public class FailedPaymentState : BasePaymentState
    {
        public FailedPaymentState(IServiceProvider sp, ApplicationDbContext ctx, IMapper mapper)
            : base(sp, ctx, mapper) { }
    }
}
