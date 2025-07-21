namespace Services.Database
{
    public class TutorSchedule
    {
        public int Id { get; set; }
        public int TutorId { get; set; }    
        public Tutor Tutor { get; set; } = null!;
        public List<AvailableDay> AvailableDays { get; set; } = new List<AvailableDay>();
        public int Duration { get; set; } //minutes
        public decimal Price { get; set; }

    }
}