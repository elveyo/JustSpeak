namespace Models.Requests
{
    public class LanguageLevelUpsertRequest
    {
        public required string Name { get; set; }
        public required string Description { get; set; }
        public required int MaxPoints { get; set; }
    }
} 