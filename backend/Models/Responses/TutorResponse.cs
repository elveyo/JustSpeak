namespace Models.Responses
{
    public class TutorResponse
    {
        public UserResponse User { get; set; }
        public List<LanguageResponse> Languages { get; set; }
        public List<CertificateResponse> Certificates { get; set; }
    }
}
