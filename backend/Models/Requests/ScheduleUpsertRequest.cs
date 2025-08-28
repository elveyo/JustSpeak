namespace Models.Requests
{
    public class ScheduleUpsertRequest
    {
        public int TutorId { get; set; }

        public List<AvailableDayDto> AvailableDays { get; set; } = [];

        public int Duration { get; set; }

        public decimal Price { get; set; }
    }

    public class AvailableDayDto
    {
        public DayOfWeek DayOfWeek { get; set; }
        public TimeSpan StartTime { get; set; }
        public TimeSpan EndTime { get; set; }
    }
}
