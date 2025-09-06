namespace Models.Responses
{
    public class BookedSessionResponse
    {
        public string Language { get; set; }
        public string Level { get; set; }

        public DateTime Date { get; set; }
        public DateTime StartTime { get; set; }
        public DateTime EndTime { get; set; }

        public bool IsActive { get; set; }

        public string UserName { get; set; }
        public string UserImageUrl { get; set; }
    }
}
