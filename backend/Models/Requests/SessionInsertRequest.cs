using System.ComponentModel.DataAnnotations;

namespace Models.Requests
{
    public class SessionUpsertRequest
{
    [Range(2, 4, ErrorMessage = "NumberOfUsers must be between 2 and 4.")]
    public int NumOfUsers { get; set; }
    public int LanguageId { get; set; }
    public int LevelId { get; set; }
    public int Duration { get; set; }
    public string ChannelName { get; set; } = String.Empty;
}

}