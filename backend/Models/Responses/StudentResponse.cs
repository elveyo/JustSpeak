namespace Models.Responses
{
    public class StudentResponse
    {
        public UserResponse User { get; set; }

        public List<LanguageLevelResponse> Languages { get; set; }
    }
}
