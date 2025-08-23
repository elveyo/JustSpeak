using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;

namespace Services.Database
{
    public class ApplicationDbContext : DbContext
    {
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
            : base(options) { }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            //Comments

            modelBuilder.Entity<Comment>(entity =>
            {
                entity
                    .HasOne(c => c.ParentComment)
                    .WithMany(c => c.Replies)
                    .HasForeignKey(c => c.ParentCommentId)
                    .OnDelete(DeleteBehavior.Restrict);

                entity
                    .HasOne(c => c.Post)
                    .WithMany(p => p.Comments)
                    .HasForeignKey(c => c.PostId)
                    .OnDelete(DeleteBehavior.Cascade);

                entity
                    .HasOne(c => c.Author)
                    .WithMany(u => u.Comments)
                    .HasForeignKey(c => c.AuthorId)
                    .OnDelete(DeleteBehavior.Restrict);
            });

            // Seed Roles
            modelBuilder
                .Entity<Role>()
                .HasData(
                    new Role { Id = 1, Name = "Admin" },
                    new Role { Id = 2, Name = "Tutor" },
                    new Role { Id = 3, Name = "Student" }
                );

            // Seed Languages
            modelBuilder
                .Entity<Language>()
                .HasData(
                    new Language { Id = 1, Name = "English" },
                    new Language { Id = 2, Name = "Bosnian" },
                    new Language { Id = 3, Name = "French" },
                    new Language { Id = 4, Name = "German" },
                    new Language { Id = 5, Name = "Japanese" }
                );

            // Seed LanguageLevels
            modelBuilder
                .Entity<LanguageLevel>()
                .HasData(
                    new LanguageLevel
                    {
                        Id = 1,
                        Name = "Wanderer",
                        Description =
                            "Embarking on the language journey, learning greetings and essential words.",
                        MaxPoints = 100,
                    },
                    new LanguageLevel
                    {
                        Id = 2,
                        Name = "Explorer",
                        Description =
                            "Navigating simple conversations and discovering basic grammar structures.",
                        MaxPoints = 200,
                    },
                    new LanguageLevel
                    {
                        Id = 3,
                        Name = "Storyteller",
                        Description =
                            "Confidently sharing stories and engaging in daily discussions.",
                        MaxPoints = 400,
                    },
                    new LanguageLevel
                    {
                        Id = 4,
                        Name = "Sage",
                        Description = "Mastering complex topics, idioms, and nuanced expressions.",
                        MaxPoints = 600,
                    },
                    new LanguageLevel
                    {
                        Id = 5,
                        Name = "Polyglot",
                        Description =
                            "Achieving legendary fluency and cultural mastery, speaking like a native.",
                        MaxPoints = 1000,
                    }
                );

            //Seed Users

            modelBuilder
                .Entity<User>()
                .HasDiscriminator<string>("Discriminator")
                .HasValue<User>("User")
                .HasValue<Admin>("Admin")
                .HasValue<Tutor>("Tutor")
                .HasValue<Student>("Student");

            modelBuilder
                .Entity<Admin>()
                .HasData(
                    new Admin
                    {
                        Id = 1,
                        FirstName = "Admin",
                        LastName = "User",
                        Email = "admin@justspeak.com",
                        PasswordHash = "hashed_password",
                        PasswordSalt = "salt",
                        IsEmailVerified = true,
                        IsActive = true,
                        RoleId = 1,
                        CreatedAt = DateTime.UtcNow,
                    }
                );
            modelBuilder
                .Entity<Tutor>()
                .HasData(
                    new Tutor
                    {
                        Id = 2,
                        FirstName = "Maria",
                        LastName = "Garcia",
                        Email = "maria@justspeak.com",
                        PasswordHash = "hashed_password",
                        PasswordSalt = "salt",
                        IsEmailVerified = true,
                        IsActive = true,
                        RoleId = 2,
                        CreatedAt = DateTime.UtcNow,
                    },
                    new Tutor
                    {
                        Id = 3,
                        FirstName = "Jean",
                        LastName = "Dubois",
                        Email = "jean@justspeak.com",
                        PasswordHash = "hashed_password",
                        PasswordSalt = "salt",
                        IsEmailVerified = true,
                        IsActive = true,
                        RoleId = 2,
                        CreatedAt = DateTime.UtcNow,
                    }
                );
            modelBuilder
                .Entity<Student>()
                .HasData(
                    new Student
                    {
                        Id = 4,
                        FirstName = "Hans",
                        LastName = "Muller",
                        Email = "hans@justspeak.com",
                        PasswordHash = "hashed_password",
                        PasswordSalt = "salt",
                        IsEmailVerified = true,
                        IsActive = true,
                        RoleId = 3,
                        CreatedAt = DateTime.UtcNow,
                    },
                    new Student
                    {
                        Id = 5,
                        FirstName = "Yuki",
                        LastName = "Tanaka",
                        Email = "yuki@justspeak.com",
                        PasswordHash = "hashed_password",
                        PasswordSalt = "salt",
                        IsEmailVerified = true,
                        IsActive = true,
                        RoleId = 3,
                        CreatedAt = DateTime.UtcNow,
                    }
                );

            // Seed Tags
            modelBuilder
                .Entity<Tag>()
                .HasData(
                    new Tag
                    {
                        Id = 1,
                        Name = "Conversation",
                        Color = "#4CAF50",
                    },
                    new Tag
                    {
                        Id = 2,
                        Name = "Grammar",
                        Color = "#2196F3",
                    },
                    new Tag
                    {
                        Id = 3,
                        Name = "Pronunciation",
                        Color = "#FF9800",
                    },
                    new Tag
                    {
                        Id = 4,
                        Name = "Travel",
                        Color = "#9C27B0",
                    },
                    new Tag
                    {
                        Id = 5,
                        Name = "Food & Cooking",
                        Color = "#FF5722",
                    },
                    new Tag
                    {
                        Id = 6,
                        Name = "Business",
                        Color = "#607D8B",
                    },
                    new Tag
                    {
                        Id = 7,
                        Name = "Culture",
                        Color = "#E91E63",
                    },
                    new Tag
                    {
                        Id = 8,
                        Name = "Daily Life",
                        Color = "#795548",
                    },
                    new Tag
                    {
                        Id = 9,
                        Name = "Hobbies",
                        Color = "#00BCD4",
                    },
                    new Tag
                    {
                        Id = 10,
                        Name = "Health & Wellness",
                        Color = "#8BC34A",
                    }
                );
        }

        public DbSet<User> Users { get; set; }
        public DbSet<Student> Students { get; set; }
        public DbSet<Tutor> Tutors { get; set; }
        public DbSet<Admin> Admins { get; set; }
        public DbSet<Post> Posts { get; set; }
        public DbSet<Comment> Comments { get; set; }
        public DbSet<Like> Likes { get; set; }
        public DbSet<Role> Roles { get; set; }
        public DbSet<TutorSchedule> Schedules { get; set; }
        public DbSet<AvailableDay> AvailableDays { get; set; }
        public DbSet<Tag> Tags { get; set; }
        public DbSet<Language> Languages { get; set; }
        public DbSet<LanguageLevel> LanguageLevels { get; set; }
        public DbSet<Session> Sessions { get; set; }
        public DbSet<Payment> Payments { get; set; }
        public DbSet<StudentLanguage> StudentLanguages { get; set; }
        public DbSet<TutorLanguage> TutorLanguages { get; set; }
        public DbSet<StudentTutorSession> StudentTutorSessions { get; set; }
        public DbSet<Certificate> Certificates { get; set; }
    }
}
