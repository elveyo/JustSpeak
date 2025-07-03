using Models.Requests;

namespace Models.Responses
{
   public class ScheduleResponse
{
    public int Id { get; set; }
    public int TutorId { get; set; }

    public List<AvailableDayDto> AvailableDays { get; set; } = new();

    public int Duration { get; set; }

    public decimal Price { get; set; }
}

}