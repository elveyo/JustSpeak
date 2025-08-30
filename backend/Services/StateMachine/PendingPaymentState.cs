using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Models.Exceptions;
using Models.Responses;
using Services.Database;

namespace Services.StateMachine
{
    public class PendingPaymentState : BasePaymentState
    {
        public PendingPaymentState(IServiceProvider sp, ApplicationDbContext ctx, IMapper mapper)
            : base(sp, ctx, mapper) { }

        public override async Task<PaymentResponse> MarkSucceededAsync(int id)
        {
            var payment = await _context.Payments.FindAsync(id);
            if (payment == null)
                throw new UserException("Payment not found");

            payment.Status = nameof(SucceededPaymentState);
            if (payment.Session != null)
                payment.Session.IsActive = true;
            await _context.SaveChangesAsync();

            return _mapper.Map<PaymentResponse>(payment);
        }

        public override async Task<PaymentResponse> MarkFailedAsync(int id)
        {
            var payment = await _context
                .Payments.Include(p => p.Session)
                .FirstOrDefaultAsync(p => p.Id == id);
            if (payment == null)
                throw new UserException("Payment not found");

            payment.Status = nameof(FailedPaymentState);
            if (payment.Session != null)
                payment.Session.IsActive = false; // neaktivna sesija
            await _context.SaveChangesAsync();

            return _mapper.Map<PaymentResponse>(payment);
        }

        public override async Task<PaymentResponse> CancelAsync(int id)
        {
            var payment = await _context
                .Payments.Include(p => p.Session)
                .FirstOrDefaultAsync(p => p.Id == id);
            if (payment == null)
                throw new UserException("Payment not found");

            payment.Status = nameof(CanceledPaymentState);
            if (payment.Session != null)
                payment.Session.IsActive = false; // neaktivna sesija
            await _context.SaveChangesAsync();

            return _mapper.Map<PaymentResponse>(payment);
        }
    }
}
