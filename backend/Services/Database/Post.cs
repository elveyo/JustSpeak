using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Services.Database
{
    public class Post
    {
        public int Id { get; set; }

        public string Title { get; set; } = null!;
        public string Content { get; set; } = null!;
        public int AuthorId { get; set; }
        public User Author { get; set; } = null!;

        public string ImageUrl { get; set; } = string.Empty;

        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;  

        [NotMapped]
        public float[] Embedding { get; set; } = Array.Empty<float>();

        public ICollection<Comment> Comments { get; set; } = new List<Comment>();
        public ICollection<Like> Likes { get; set; } = new List<Like>();
    }
}
