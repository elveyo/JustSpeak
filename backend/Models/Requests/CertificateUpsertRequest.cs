namespace Models.Requests
{
    public class CertificateUpsertRequest
    {
        public string Name { get; set; } = string.Empty;
        public string ImageUrl { get; set; } = string.Empty;

        public int TutorId { get; set; }
        public int LanguageId { get; set; }
    }
}
