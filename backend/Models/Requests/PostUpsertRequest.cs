namespace Models.Requests
{
    public class PostUpsertRequest
    {
        public required string Title { get; set; }
        public required string Content { get; set; }
        public string? ImageUrl { get; set; }
        public int? AuthorId { get; set; }
    }
}
