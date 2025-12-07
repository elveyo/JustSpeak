namespace Models.Responses
{
    public class BookedSessionResponse
    {
        public string Language { get; set; }
        public int LanguageId { get; set; }
        public string Level { get; set; }
        public int LevelId { get; set; }

        public DateTime Date { get; set; }
        public DateTime StartTime { get; set; }
        public DateTime EndTime { get; set; }

        public bool IsActive { get; set; }
        public bool IsCompleted { get; set; }
        public string? Note { get; set; }

        public int Id { get; set; }
        public string ChannelName { get; set; }
        public string UserName { get; set; }
        public string UserImageUrl { get; set; }
    }
}
