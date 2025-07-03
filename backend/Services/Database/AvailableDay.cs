namespace Services.Database
{
  public class AvailableDay
{
    public int Id { get; set; } 
    public int TutorScheduleId { get; set; } 
    public TutorSchedule TutorSchedule { get; set; } = null!;

    public DayOfWeek DayOfWeek { get; set; }
    public TimeSpan StartTime { get; set; }
    public TimeSpan EndTime { get; set; }
}

}