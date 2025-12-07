namespace Models.Responses
{
    public class TutorResponse
    {
        public UserResponse User { get; set; }
        public List<LanguageResponse> Languages { get; set; }
        public List<CertificateResponse> Certificates { get; set; }
        public int SessionCount { get; set; }
        public int StudentCount { get; set; }
        public decimal? Price { get; set; }
        public bool HasSchedule { get; set; }
    }
}
