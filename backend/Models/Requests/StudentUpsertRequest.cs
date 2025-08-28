using Models.Responses;

namespace Models.Requests
{
    public class StudentUpsertRequest
    {
        public UserInsertRequest User { get; set; }
        public List<LanguageLevelUpsertRequest> Languages { get; set; } = null!;
    }
}
