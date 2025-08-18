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

        // Koji dan u sedmici (0=Sunday, 1=Monday, ... 6=Saturday)
        public DayOfWeek DayOfWeek { get; set; }

        // Vrijeme od - do
        public TimeSpan StartTime { get; set; }
        public TimeSpan EndTime { get; set; }

        public List<AvailableSlot> Slots { get; set; } = new List<AvailableSlot>();
    }

    public class AvailableSlot
    {
        public int Id { get; set; }
        public int AvailableDayId { get; set; }
        public AvailableDay AvailableDay { get; set; } = null!;

        public TimeSpan StartTime { get; set; }
        public TimeSpan EndTime { get; set; }
        public bool IsBooked { get; set; } = false;
    }
}
