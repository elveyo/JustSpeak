namespace Services.Database
{
    public class Tag
    {
        public int Id { get; set; }
        public string Name { get; set; } = String.Empty;
        public string Color { get; set; } = String.Empty;
        ICollection<Session> Sessions {get;set;} = new List<Session>();
    }
}