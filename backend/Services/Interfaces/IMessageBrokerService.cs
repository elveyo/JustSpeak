using System;

namespace Services.Interfaces
{
    public interface IMessageBrokerService
    {
        void Publish<T>(T message, string queueName);
    }
}
