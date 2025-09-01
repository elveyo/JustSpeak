namespace Models.Messages
{
    public class SessionBookedMessage
    {
        public string TutorEmail { get; set; } = null!;
        public string StudentName { get; set; } = null!;
        public DateTime Time { get; set; }
    }
}
