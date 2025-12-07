using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using DotNetEnv;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Model.Responses;
using Model.SearchObjects;
using Models.Requests;
using Models.Responses;
using Services.Database;
using Services.Interfaces;
using Stripe;

namespace Services.Services
{
    public class PaymentService
        : BaseCRUDService<
            PaymentResponse,
            PaymentSearchObject,
            Payment,
            PaymentInsertRequest,
            PaymentUpdateRequest
        >,
            IPaymentService
    {
        public PaymentService(ApplicationDbContext context, IMapper mapper)
            : base(context, mapper) { }

        public override async Task<PagedResult<PaymentResponse>> GetAsync(
            PaymentSearchObject? search
        )
        {
            var query = _context
                .Set<Payment>()
                .Include(p => p.Session)
                .Include(p => p.Session.Student)
                .Include(p => p.Session.Tutor)
                .AsQueryable();

            if (search != null)
            {
                if (!string.IsNullOrWhiteSpace(search.FTS))
                {
                    var nameQuery = search.FTS.Trim().ToLower();
                    query = query.Where(p =>
                        p.Session.Student.FirstName.ToLower().Contains(nameQuery)
                        || p.Session.Student.LastName.ToLower().Contains(nameQuery)
                        || p.Session.Tutor.FirstName.ToLower().Contains(nameQuery)
                        || p.Session.Tutor.LastName.ToLower().Contains(nameQuery)
                    );
                }
            }
            if (search?.Status != null)
            {
                query = query.Where(p => p.Status == search.Status);
            }

            var totalCount = await query.CountAsync();

            if (search?.Page.HasValue == true && search?.PageSize.HasValue == true)
            {
                query = query
                    .Skip(search.Page.Value * search.PageSize.Value)
                    .Take(search.PageSize.Value);
            }

            var payments = await query.ToListAsync();

            var responses = payments
                .Select(payment => new PaymentResponse
                {
                    Id = payment.Id,
                    SessionId = payment.SessionId,
                    Sender = payment.Session.Student.FullName,
                    Recipient = payment.Session.Tutor.FullName,
                    Amount = payment.Amount,
                    Status = payment.Status,
                    CreatedAt = payment.CreatedAt,
                })
                .ToList();

            return new PagedResult<PaymentResponse> { Items = responses, TotalCount = totalCount };
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
