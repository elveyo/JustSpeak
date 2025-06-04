namespace Models.Requests
{
    public class CommentUpsertRequest
    {
        public string Content { get; set; }
        public int PostId { get; set; }
        public int AuthorId { get; set; }
        public int? ParentCommentId { get; set; }
    }
}