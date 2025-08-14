using System.Formats.Asn1;
namespace Models.Responses
{
    public class SessionResponse
    {
        public int Id { get; set; }
        public string Language { get; set; }
        public string Level { get; set; }
        public int NumOfUsers { get; set; }
        public int Duration { get; set; }
        public DateTime CreatedAt { get; set; }
        public string? ChannelName { get; set; }
        public string? Token { get; set; }
        public List<TagResponse> Tags { get; set; } = new();
    }
}