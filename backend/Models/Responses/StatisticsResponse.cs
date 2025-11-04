namespace Models.Responses
{
    public class StatisticsResponse
    {
        public int StudentsNum { get; set; }
        public int TutorsNum { get; set; }
        public int SessionsNum { get; set; }
        public List<Dictionary<int, int>> Users { get; set; }
        public List<Dictionary<int, int>> Sessions { get; set; }
    }
}
