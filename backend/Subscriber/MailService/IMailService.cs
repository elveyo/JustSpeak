namespace Subscriber.MailService
{
    public interface IMailService
    {
        Task SendEmail(Email emailObj);
    }
}
