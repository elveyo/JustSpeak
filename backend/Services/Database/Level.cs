using System.ComponentModel.DataAnnotations;

namespace Services.Database
{
    public class Level
    {
        public int Id { get; set; }

        public string Name { get; set; } = string.Empty;

        public string Description { get; set; } = string.Empty;

        public int MaxPoints { get; set; }

        public int Order { get; set; }
    }
}
