using MailKit.Net.Smtp;
using MailKit.Security;
using MimeKit;
using Models.Messages;
using Subscriber;

namespace Subscriber.MailService
{
    public class MailService : IMailService
    {
        private readonly string _fromAddress;
        private readonly string _password;
        private readonly string _host;
        private readonly int _port;
        private readonly string _displayName;
        private readonly int _timeout;

        public MailService()
        {
            _fromAddress =
                Environment.GetEnvironmentVariable("_fromAddress") ?? "elviragic33@gmail.com";
            _password = Environment.GetEnvironmentVariable("_password") ?? string.Empty;
            _host = Environment.GetEnvironmentVariable("_host") ?? "smtp.gmail.com";
            _port = int.Parse(Environment.GetEnvironmentVariable("_port") ?? "587");
            _displayName = Environment.GetEnvironmentVariable("_displayName") ?? "no-reply";
            _timeout = int.Parse(Environment.GetEnvironmentVariable("_timeout") ?? "30");
        }

        public async Task SendEmail(Email emailObj)
        {
            Console.WriteLine("Sending email...");
            Console.WriteLine(emailObj);
            if (emailObj == null)
                return;
            if (string.IsNullOrEmpty(_password))
                throw new Exception("SMTP password not configured");

            var message = new MimeMessage();
            message.From.Add(new MailboxAddress(_displayName, _fromAddress));
            message.To.Add(new MailboxAddress(emailObj.ReceiverName, emailObj.EmailTo));
            message.Subject = emailObj.Subject;
            message.Body = new TextPart("html") { Text = emailObj.Message };

            using var smtp = new SmtpClient { Timeout = _timeout * 1000 };

            try
            {
                Console.WriteLine("Connecting to SMTP...");
                await smtp.ConnectAsync(_host, _port, SecureSocketOptions.StartTls);

                Console.WriteLine("Authenticating...");
                await smtp.AuthenticateAsync(_fromAddress, _password);

                await smtp.SendAsync(message);
                Console.WriteLine("Mail sent successfully.");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"SMTP error: {ex.Message}");
                throw;
            }
            finally
            {
                await smtp.DisconnectAsync(true);
            }
        }
    }
}
