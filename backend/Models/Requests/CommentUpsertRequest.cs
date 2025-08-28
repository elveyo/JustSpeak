namespace Models.Requests
{
    public class CommentUpsertRequest
    {
        public string Content { get; set; }
        public int? ParentCommentId { get; set; }
    }
}
