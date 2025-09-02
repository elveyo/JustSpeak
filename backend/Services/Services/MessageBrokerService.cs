using EasyNetQ;
using Services.Interfaces;

public class MessageBrokerService : IMessageBrokerService
{
    private readonly string _rabbitMqHost =
        Environment.GetEnvironmentVariable("RABBITMQ_HOST") ?? "localhost";
    private readonly string _rabbitMqUsername =
        Environment.GetEnvironmentVariable("RABBITMQ_USERNAME") ?? "guest";
    private readonly string _rabbitMqPassword =
        Environment.GetEnvironmentVariable("RABBITMQ_PASSWORD") ?? "guest";

    private readonly string connectionString =
        $"host={Environment.GetEnvironmentVariable("RABBITMQ_HOST") ?? "localhost"};username={Environment.GetEnvironmentVariable("RABBITMQ_USERNAME") ?? "guest"};password={Environment.GetEnvironmentVariable("RABBITMQ_PASSWORD") ?? "guest"}";

    public void Publish<T>(T message, string queueName)
    {
        var _bus = RabbitHutch.CreateBus(connectionString);

        _bus.PubSub.Publish(message);
    }
}
