namespace Models.Requests
{
    public class RateUserRequest
    {
        public int SessionId { get; set; }
        public int LanguageId { get; set; }
        public int LevelId { get; set; }
        public List<UserRatingItem> Ratings { get; set; } = new List<UserRatingItem>();
    }

    public class UserRatingItem
    {
        public int UserId { get; set; }
        public int Rating { get; set; } // 1-5
    }
}
