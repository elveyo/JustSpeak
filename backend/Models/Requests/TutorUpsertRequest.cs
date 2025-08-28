namespace Models.Requests
{
    public class TutorUpsertRequest
    {
        public UserInsertRequest User { get; set; }
        public List<LanguageLevelUpsertRequest> Languages { get; set; }
        public List<CertificateUpsertRequest>? Certificates { get; set; }
    }
}
