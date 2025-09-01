using System.Text;
using Mapster;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using Services;
using Services.Database;
using Services.Interfaces;
using Services.Services;
using Stripe;
using WebAPI.Hubs;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddDbContext<ApplicationDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("JustSpeakDB"))
);
builder.Services.AddMapster();

builder.Services.AddControllers();

// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.AddHttpContextAccessor();
builder.Services.AddTransient<IUserContextService, UserContextService>();

builder.Services.AddTransient<ITokenService, Services.Services.TokenService>();
builder.Services.AddTransient<IUserService, UserService>();
builder.Services.AddTransient<ICommentService, CommentService>();
builder.Services.AddTransient<IPostService, PostService>();
builder.Services.AddTransient<IScheduleService, ScheduleService>();
builder.Services.AddTransient<ISessionService, SessionService>();
builder.Services.AddTransient<ILanguageService, LanguageService>();
builder.Services.AddTransient<ILevelService, LevelService>();
builder.Services.AddTransient<IPaymentService, PaymentService>();

//Payment machine state
builder.Services.AddTransient<Services.StateMachine.BasePaymentState>();
builder.Services.AddTransient<Services.StateMachine.InitialPaymentState>();
builder.Services.AddTransient<Services.StateMachine.CanceledPaymentState>();
builder.Services.AddTransient<Services.StateMachine.SucceededPaymentState>();
builder.Services.AddTransient<Services.StateMachine.FailedPaymentState>();

//Stripe configuration
var stripeKey = builder.Configuration.GetValue<string>("Stripe:_stripe");
if (string.IsNullOrEmpty(stripeKey))
{
    throw new InvalidOperationException(
        "Stripe API key is not configured. Please check your appsettings.json or environment variables."
    );
}
StripeConfiguration.ApiKey = stripeKey;

// Add SignalR
builder.Services.AddSignalR();

builder
    .Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        options.TokenValidationParameters = new TokenValidationParameters()
        {
            ValidateIssuer = true,
            ValidIssuer = builder.Configuration.GetValue<string>("JWT:Issuer"),
            ValidateAudience = false,
            ValidateLifetime = true,
            ClockSkew = TimeSpan.Zero,
            ValidateIssuerSigningKey = true,
            IssuerSigningKey = new SymmetricSecurityKey(
                Encoding.UTF8.GetBytes(builder.Configuration.GetValue<string>("JWT:SecurityKey"))
            ),
        };
    });
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo { Title = "API", Version = "v1" });

    c.AddSecurityDefinition(
        "Bearer",
        new OpenApiSecurityScheme
        {
            Name = "Authorization",
            Type = SecuritySchemeType.Http,
            BearerFormat = "JWT",
            Scheme = "bearer",
            In = ParameterLocation.Header,
            Description = "Please enter JWT token",
        }
    );

    c.AddSecurityRequirement(
        new OpenApiSecurityRequirement
        {
            {
                new OpenApiSecurityScheme
                {
                    Reference = new OpenApiReference
                    {
                        Type = ReferenceType.SecurityScheme,
                        Id = "Bearer",
                    },
                },
                new string[] { }
            },
        }
    );
});

/* builder.WebHost.ConfigureKestrel(options =>
{
    options.ListenAnyIP(5280);
}); */

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

//app.UseHttpsRedirection();

app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();

using (var scope = app.Services.CreateScope())
{
    var dataContext = scope.ServiceProvider.GetRequiredService<ApplicationDbContext>();
    dataContext.Database.Migrate();
}

app.Run();
