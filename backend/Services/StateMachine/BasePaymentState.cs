using MapsterMapper;
using Microsoft.Extensions.DependencyInjection;
using Models.Exceptions;
using Models.Requests;
using Models.Responses;
using Services.Database;

namespace Services.StateMachine
{
    public class BasePaymentState
    {
        protected readonly IServiceProvider _serviceProvider;
        protected readonly ApplicationDbContext _context;
        protected readonly IMapper _mapper;

        public BasePaymentState(
            IServiceProvider serviceProvider,
            ApplicationDbContext context,
            IMapper mapper
        )
        {
            _serviceProvider = serviceProvider;
            _context = context;
            _mapper = mapper;
        }

        public virtual async Task<PaymentResponse> CreateAsync(PaymentInsertRequest request)
        {
            throw new UserException("Not allowed in current state");
        }

        public virtual async Task<PaymentResponse> MarkSucceededAsync(int id)
        {
            throw new UserException("Not allowed in current state");
        }

        public virtual async Task<PaymentResponse> MarkFailedAsync(int id)
        {
            throw new UserException("Not allowed in current state");
        }

        public virtual async Task<PaymentResponse> CancelAsync(int id)
        {
            throw new UserException("Not allowed in current state");
        }

        public BasePaymentState GetPaymentState(string stateName)
        {
            switch (stateName)
            {
                case nameof(InitialPaymentState):
                    return _serviceProvider.GetService<InitialPaymentState>();
                case nameof(PendingPaymentState):
                    return _serviceProvider.GetService<PendingPaymentState>();
                case nameof(SucceededPaymentState):
                    return _serviceProvider.GetService<SucceededPaymentState>();
                case nameof(FailedPaymentState):
                    return _serviceProvider.GetService<FailedPaymentState>();
                case nameof(CanceledPaymentState):
                    return _serviceProvider.GetService<CanceledPaymentState>();
                default:
                    throw new Exception($"State {stateName} not defined");
            }
        }
    }
}
