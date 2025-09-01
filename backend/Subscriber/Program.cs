using System;
using System.Threading.Tasks;
using EasyNetQ;
using Models.Messages;
using Subscriber.MailService;

IMailService mailService = new MailService();
Console.WriteLine("Starting Subscriber...");

var rabbitMqHost = Environment.GetEnvironmentVariable("RABBITMQ_HOST") ?? "localhost";
var rabbitMqUsername = Environment.GetEnvironmentVariable("RABBITMQ_USERNAME") ?? "guest";
var rabbitMqPassword = Environment.GetEnvironmentVariable("RABBITMQ_PASSWORD") ?? "guest";

var rabbitMqConnectionString =
    $"host={rabbitMqHost};username={rabbitMqUsername};password={rabbitMqPassword}";
var bus = RabbitHutch.CreateBus(rabbitMqConnectionString);

await bus.PubSub.SubscribeAsync<SessionBookedMessage>(
    "session-booked",
    msg =>
    {
        mailService.SendEmail(
            new Email
            {
                EmailTo = msg.TutorEmail,
                ReceiverName = msg.TutorEmail,
                Subject = "Session booked",
                Message = $"Session booked by {msg.StudentName} at {msg.Time}",
            }
        );
        return Task.CompletedTask;
    }
);

Console.WriteLine("Listening for messages...");

await Task.Delay(Timeout.Infinite);
