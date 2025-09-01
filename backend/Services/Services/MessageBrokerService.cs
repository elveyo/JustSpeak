using EasyNetQ;
using Services.Interfaces;

public class MessageBrokerService : IMessageBrokerService
{
    private readonly IBus _bus;

    public MessageBrokerService(string connectionString)
    {
        _bus = RabbitHutch.CreateBus(connectionString);
    }

    public void Publish<T>(T message, string queueName)
    {
        _bus.PubSub.Publish(message);
    }
}
