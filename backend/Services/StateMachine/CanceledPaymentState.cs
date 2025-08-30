using MapsterMapper;
using Services.Database;

namespace Services.StateMachine
{
    public class CanceledPaymentState : BasePaymentState
    {
        public CanceledPaymentState(IServiceProvider sp, ApplicationDbContext ctx, IMapper mapper)
            : base(sp, ctx, mapper) { }
    }
}
