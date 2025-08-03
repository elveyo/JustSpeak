namespace Models.Responses
{
    public class PostResponse
    {
        public int Id { get; set; }
        public string Content { get; set; }
        public DateTime CreatedAt { get; set; } = DateTime.Now.AddDays(-new Random().Next(0, 3650));
        public int AuthorId { get; set; }
        public string AuthorName { get; set; }

        public string ImageUrl { get; set; }

        public int NumOfLikes { get; set; }
        public int NumOfComments { get; set; }
        public string UserRole { get; set; }

        public bool LikedByCurrUser { get; set; }
        
    }
}