namespace Models.Requests
{
    public class UserInsertRequest
    {
        public string FirstName { get; set; } = string.Empty;
        public string LastName { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string Password { get; set; } = string.Empty;

        public List<LanguageLevelUpsertRequest> Languages { get; set; }
        public string? ImageUrl { get; set; }
        public string? Bio { get; set; }
        public int RoleId { get; set; }
    }
}
