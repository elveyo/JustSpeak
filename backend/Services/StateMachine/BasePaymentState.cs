using MapsterMapper;
using Models.Exceptions;
using Models.Responses;
using Services.Database;

namespace Services.StateMachine
{
    public class BaseProductState
    {
        protected readonly IServiceProvider _serviceProvider;
        protected readonly ApplicationDbContext _context;
        protected readonly IMapper _mapper;

        public BaseProductState(
            IServiceProvider serviceProvider,
            ApplicationDbContext context,
            IMapper mapper
        )
        {
            _serviceProvider = serviceProvider;
            _context = context;
            _mapper = mapper;
        }

        public virtual async Task<PaymentResponse> CreateAsync(ProductInsertRequest request)
        {
            throw new UserException("Not allowed");
        }

        public virtual async Task<PaymentResponse> UpdateAsync(int id, ProductUpdateRequest request)
        {
            throw new UserException("Not allowed");
        }

        public BaseProductState GetProductState(string stateName)
        {
            switch (stateName)
            {
                case "InitialProductState":
                    return _serviceProvider.GetService<InitialProductState>();
                case nameof(DraftProductState):
                    return _serviceProvider.GetService<DraftProductState>();
                case nameof(ActiveProductState):
                    return _serviceProvider.GetService<ActiveProductState>();
                case nameof(DeactivatedProductState):
                    return _serviceProvider.GetService<DeactivatedProductState>();

                default:
                    throw new Exception($"State {stateName} not defined");
            }
        }

        public virtual List<string> AllowedActions(int id)
        {
            throw new UserException("Metoda nije dozvoljena");
        }
    }
}
