using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Services.Database
{
    public class ApplicationDbContext : DbContext
    {
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options)
        {
            
        }
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            //Comments
           

            modelBuilder.Entity<Comment>(entity =>
            {
                entity.HasOne(c => c.ParentComment)
                        .WithMany(c => c.Replies)
                        .HasForeignKey(c => c.ParentCommentId)
                        .OnDelete(DeleteBehavior.Restrict);

                entity.HasOne(c => c.Post)
                      .WithMany(p => p.Comments)
                      .HasForeignKey(c => c.PostId)
                      .OnDelete(DeleteBehavior.Cascade);

                entity.HasOne(c => c.Author)
                      .WithMany(u => u.Comments)
                      .HasForeignKey(c => c.AuthorId)
                      .OnDelete(DeleteBehavior.Restrict);
            });

        }


        public DbSet<User> Users { get; set; }
        public DbSet<Student> Students { get; set; }
        public DbSet<Tutor> Tutors { get; set; }
        public DbSet<Post> Posts { get; set; }
        public DbSet<Comment> Comments { get; set; }
        public DbSet<Like> Likes { get; set; }
        public DbSet<Role> Roles { get; set; }
         public DbSet<TutorSchedule> Schedules { get; set; }
         public DbSet<AvailableDay> AvailableDays { get; set; }

    }
}
