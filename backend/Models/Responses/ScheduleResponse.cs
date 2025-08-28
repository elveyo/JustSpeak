using Models.Requests;

namespace Models.Responses
{
    public class ScheduleResponse
    {
        public int Id { get; set; }
        public int TutorId { get; set; }
        public List<ScheduleSlot> Slots { get; set; } = new();
        public int Duration { get; set; }

        public decimal Price { get; set; }
    }

    public class ScheduleSlot
    {
        public DateTime Date { get; set; } // konkretan datum
        public DateTime Start { get; set; } // datum + vrijeme početka
        public DateTime End { get; set; } // datum + vrijeme kraja
        public bool IsBooked { get; set; }
    }
}
