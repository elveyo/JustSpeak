using Models.Requests;

namespace Models.Responses
{
   public class ScheduleResponse
{
    public int Id { get; set; }
    public int TutorId { get; set; }
public List<WeeklyAvailability> WeeklyAvailability { get; set; } = new();
    public int Duration { get; set; }

    public decimal Price { get; set; }
}

public class WeeklyAvailability{
    public DayOfWeek DayOfWeek { get; set; }
    public List<TimeSpanPair> TimeSpans { get; set; } = new();
}

public class TimeSpanPair
{
    public TimeSpan Start { get; set; }
    public TimeSpan End { get; set; }
}

}