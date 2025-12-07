namespace Services.Database
{
    public class SessionParticipant
    {
        public int Id { get; set; }
        public int SessionId { get; set; }
        public Session Session { get; set; } = null!;
        public int UserId { get; set; }
        public User User { get; set; } = null!;
        public DateTime JoinedAt { get; set; } = DateTime.UtcNow;
    }
}
