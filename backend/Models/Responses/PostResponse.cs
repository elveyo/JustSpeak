namespace Models.Responses
{
    public class PostResponse
    {
        public int Id { get; set; }
        public string Content { get; set; } = String.Empty;
        public DateTime CreatedAt { get; set; }
        public int AuthorId { get; set; }
        public string AuthorName { get; set; } = String.Empty;
        public string AuthorImageUrl { get; set; } = String.Empty;

        public string ImageUrl { get; set; } = String.Empty;

        public int NumOfLikes { get; set; }
        public int NumOfComments { get; set; }
        public string UserRole { get; set; } = String.Empty;

        public bool LikedByCurrUser { get; set; }
    }
}
