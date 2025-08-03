using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;

namespace Services.Database
{
    [Index(nameof(UserId), nameof(PostId), IsUnique = true, Name = "IX_Like_User_Post")]
    [Index(nameof(UserId), nameof(CommentId), IsUnique = true, Name = "IX_Like_User_Comment")]
    public class Like
    {
        public int Id { get; set; }

        public int UserId { get; set; }
        public User User { get; set; } = null!;
        public int? PostId { get; set; }
        public Post? Post { get; set; }
        public int? CommentId { get; set; }
        public Comment? Comment { get; set; }

        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    }

}
