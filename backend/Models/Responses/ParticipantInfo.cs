namespace Models.Responses
{
    public class ParticipantInfo
    {
        public int UserId { get; set; }
        public string Name { get; set; } = string.Empty;
        public string? ImageUrl { get; set; }
    }
}
