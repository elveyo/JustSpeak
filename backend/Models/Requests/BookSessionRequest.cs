namespace Models.Requests
{
    public class BookSessionRequest
    {
        public int TutorId { get; set; }
        public int StudentId { get; set; }
        public int LanguageId { get; set; }
        public int LevelId { get; set; }
        public int Price { get; set; }
        public DateTime StartTime { get; set; } // datum + vrijeme u UTC
    }
}
