namespace Services.Database
{
    public class TutorSchedule
    {
        public int Id { get; set; }
        public int TutorId { get; set; }
        public Tutor Tutor { get; set; } = null!;

        // Lista dostupnih dana i termina
        public List<AvailableDay> AvailableDays { get; set; } = new List<AvailableDay>();

        public int Duration { get; set; } // u minutama
        public decimal Price { get; set; }
    }

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
