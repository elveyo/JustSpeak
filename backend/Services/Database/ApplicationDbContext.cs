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
                .Entity<Level>()
                .HasData(
                    new Level
                    {
                        Id = 1,
                        Name = "Wanderer",
                        Description =
                            "Embarking on the language journey, learning greetings and essential words.",
                        MaxPoints = 100,
                        Order = 1,
                    },
                    new Level
                    {
                        Id = 2,
                        Name = "Explorer",
                        Description =
                            "Navigating simple conversations and discovering basic grammar structures.",
                        MaxPoints = 200,
                        Order = 2,
                    },
                    new Level
                    {
                        Id = 3,
                        Name = "Storyteller",
                        Description =
                            "Confidently sharing stories and engaging in daily discussions.",
                        MaxPoints = 400,
                        Order = 3,
                    },
                    new Level
                    {
                        Id = 4,
                        Name = "Sage",
                        Description = "Mastering complex topics, idioms, and nuanced expressions.",
                        MaxPoints = 600,
                        Order = 4,
                    },
                    new Level
                    {
                        Id = 5,
                        Name = "Polyglot",
                        Description =
                            "Achieving legendary fluency and cultural mastery, speaking like a native.",
                        MaxPoints = 1000,
                        Order = 5,
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

            var passwordHash = "FwwLVIQL84DVKossXEHd0t7yQCaQDGlkEKcND+nsCEQ=";
            var passwordSalt = "vew6OzACMpTcQjQiOQEgEQ==";
            var baseDate = DateTime.UtcNow;

            // Seed Admin
            modelBuilder
                .Entity<Admin>()
                .HasData(
                    new Admin
                    {
                        Id = 1,
                        FirstName = "Admin",
                        LastName = "User",
                        Email = "admin@justspeak.com",
                        PasswordHash = passwordHash,
                        PasswordSalt = passwordSalt,
                        CreatedAt = baseDate,
                    }
                );

            // Seed 5 Tutors
            modelBuilder
                .Entity<Tutor>()
                .HasData(
                    new Tutor
                    {
                        Id = 2,
                        FirstName = "Sarah",
                        LastName = "Johnson",
                        Email = "sarah.johnson@justspeak.com",
                        PasswordHash = passwordHash,
                        PasswordSalt = passwordSalt,
                        CreatedAt = baseDate,
                        Bio = "Experienced English and French tutor with 10+ years of teaching.",
                    },
                    new Tutor
                    {
                        Id = 3,
                        FirstName = "Michael",
                        LastName = "Chen",
                        Email = "michael.chen@justspeak.com",
                        PasswordHash = passwordHash,
                        PasswordSalt = passwordSalt,
                        CreatedAt = baseDate,
                        Bio = "Native Japanese speaker, also fluent in English and German.",
                    },
                    new Tutor
                    {
                        Id = 4,
                        FirstName = "Emma",
                        LastName = "Williams",
                        Email = "emma.williams@justspeak.com",
                        PasswordHash = passwordHash,
                        PasswordSalt = passwordSalt,
                        CreatedAt = baseDate,
                        Bio = "Passionate about teaching German and Bosnian languages.",
                    },
                    new Tutor
                    {
                        Id = 5,
                        FirstName = "David",
                        LastName = "Martinez",
                        Email = "david.martinez@justspeak.com",
                        PasswordHash = passwordHash,
                        PasswordSalt = passwordSalt,
                        CreatedAt = baseDate,
                        Bio = "Multilingual tutor specializing in French and English conversation.",
                    },
                    new Tutor
                    {
                        Id = 6,
                        FirstName = "Lisa",
                        LastName = "Anderson",
                        Email = "lisa.anderson@justspeak.com",
                        PasswordHash = passwordHash,
                        PasswordSalt = passwordSalt,
                        CreatedAt = baseDate,
                        Bio = "Expert in Japanese and Bosnian with cultural immersion focus.",
                    }
                );

            // Seed 5 Students
            modelBuilder
                .Entity<Student>()
                .HasData(
                    new Student
                    {
                        Id = 7,
                        FirstName = "James",
                        LastName = "Brown",
                        Email = "james.brown@justspeak.com",
                        PasswordHash = passwordHash,
                        PasswordSalt = passwordSalt,
                        CreatedAt = baseDate,
                    },
                    new Student
                    {
                        Id = 8,
                        FirstName = "Maria",
                        LastName = "Garcia",
                        Email = "maria.garcia@justspeak.com",
                        PasswordHash = passwordHash,
                        PasswordSalt = passwordSalt,
                        CreatedAt = baseDate,
                    },
                    new Student
                    {
                        Id = 9,
                        FirstName = "Robert",
                        LastName = "Taylor",
                        Email = "robert.taylor@justspeak.com",
                        PasswordHash = passwordHash,
                        PasswordSalt = passwordSalt,
                        CreatedAt = baseDate,
                    },
                    new Student
                    {
                        Id = 10,
                        FirstName = "Jennifer",
                        LastName = "Davis",
                        Email = "jennifer.davis@justspeak.com",
                        PasswordHash = passwordHash,
                        PasswordSalt = passwordSalt,
                        CreatedAt = baseDate,
                    },
                    new Student
                    {
                        Id = 11,
                        FirstName = "William",
                        LastName = "Wilson",
                        Email = "william.wilson@justspeak.com",
                        PasswordHash = passwordHash,
                        PasswordSalt = passwordSalt,
                        CreatedAt = baseDate,
                    }
                );

            // Seed TutorLanguages (2 languages per tutor)
            modelBuilder
                .Entity<TutorLanguage>()
                .HasData(
                    // Sarah (ID 2) - English (1) and French (3)
                    new TutorLanguage
                    {
                        Id = 1,
                        TutorId = 2,
                        LanguageId = 1,
                        LevelId = 5,
                        Experience = 10,
                        PricePerHour = 35,
                    },
                    new TutorLanguage
                    {
                        Id = 2,
                        TutorId = 2,
                        LanguageId = 3,
                        LevelId = 4,
                        Experience = 8,
                        PricePerHour = 30,
                    },
                    // Michael (ID 3) - Japanese (5) and English (1)
                    new TutorLanguage
                    {
                        Id = 3,
                        TutorId = 3,
                        LanguageId = 5,
                        LevelId = 5,
                        Experience = 15,
                        PricePerHour = 40,
                    },
                    new TutorLanguage
                    {
                        Id = 4,
                        TutorId = 3,
                        LanguageId = 1,
                        LevelId = 4,
                        Experience = 12,
                        PricePerHour = 35,
                    },
                    // Emma (ID 4) - German (4) and Bosnian (2)
                    new TutorLanguage
                    {
                        Id = 5,
                        TutorId = 4,
                        LanguageId = 4,
                        LevelId = 5,
                        Experience = 9,
                        PricePerHour = 32,
                    },
                    new TutorLanguage
                    {
                        Id = 6,
                        TutorId = 4,
                        LanguageId = 2,
                        LevelId = 5,
                        Experience = 11,
                        PricePerHour = 28,
                    },
                    // David (ID 5) - French (3) and English (1)
                    new TutorLanguage
                    {
                        Id = 7,
                        TutorId = 5,
                        LanguageId = 3,
                        LevelId = 5,
                        Experience = 7,
                        PricePerHour = 30,
                    },
                    new TutorLanguage
                    {
                        Id = 8,
                        TutorId = 5,
                        LanguageId = 1,
                        LevelId = 5,
                        Experience = 6,
                        PricePerHour = 28,
                    },
                    // Lisa (ID 6) - Japanese (5) and Bosnian (2)
                    new TutorLanguage
                    {
                        Id = 9,
                        TutorId = 6,
                        LanguageId = 5,
                        LevelId = 4,
                        Experience = 8,
                        PricePerHour = 38,
                    },
                    new TutorLanguage
                    {
                        Id = 10,
                        TutorId = 6,
                        LanguageId = 2,
                        LevelId = 5,
                        Experience = 10,
                        PricePerHour = 25,
                    }
                );

            // Seed StudentLanguages (2 languages per student with random levels and points)
            modelBuilder
                .Entity<StudentLanguage>()
                .HasData(
                    // James (ID 7) - English (1) Level 2 (75 points), French (3) Level 1 (45 points)
                    new StudentLanguage
                    {
                        Id = 1,
                        StudentId = 7,
                        LanguageId = 1,
                        LevelId = 2,
                        Points = 75,
                        DateAdded = baseDate.AddDays(-30),
                    },
                    new StudentLanguage
                    {
                        Id = 2,
                        StudentId = 7,
                        LanguageId = 3,
                        LevelId = 1,
                        Points = 45,
                        DateAdded = baseDate.AddDays(-15),
                    },
                    // Maria (ID 8) - German (4) Level 3 (320 points), Japanese (5) Level 1 (85 points)
                    new StudentLanguage
                    {
                        Id = 3,
                        StudentId = 8,
                        LanguageId = 4,
                        LevelId = 3,
                        Points = 320,
                        DateAdded = baseDate.AddDays(-60),
                    },
                    new StudentLanguage
                    {
                        Id = 4,
                        StudentId = 8,
                        LanguageId = 5,
                        LevelId = 1,
                        Points = 85,
                        DateAdded = baseDate.AddDays(-20),
                    },
                    // Robert (ID 9) - Bosnian (2) Level 4 (550 points), English (1) Level 2 (120 points)
                    new StudentLanguage
                    {
                        Id = 5,
                        StudentId = 9,
                        LanguageId = 2,
                        LevelId = 4,
                        Points = 550,
                        DateAdded = baseDate.AddDays(-90),
                    },
                    new StudentLanguage
                    {
                        Id = 6,
                        StudentId = 9,
                        LanguageId = 1,
                        LevelId = 2,
                        Points = 120,
                        DateAdded = baseDate.AddDays(-45),
                    },
                    // Jennifer (ID 10) - French (3) Level 1 (60 points), German (4) Level 2 (180 points)
                    new StudentLanguage
                    {
                        Id = 7,
                        StudentId = 10,
                        LanguageId = 3,
                        LevelId = 1,
                        Points = 60,
                        DateAdded = baseDate.AddDays(-25),
                    },
                    new StudentLanguage
                    {
                        Id = 8,
                        StudentId = 10,
                        LanguageId = 4,
                        LevelId = 2,
                        Points = 180,
                        DateAdded = baseDate.AddDays(-50),
                    },
                    // William (ID 11) - Japanese (5) Level 3 (380 points), Bosnian (2) Level 1 (95 points)
                    new StudentLanguage
                    {
                        Id = 9,
                        StudentId = 11,
                        LanguageId = 5,
                        LevelId = 3,
                        Points = 380,
                        DateAdded = baseDate.AddDays(-75),
                    },
                    new StudentLanguage
                    {
                        Id = 10,
                        StudentId = 11,
                        LanguageId = 2,
                        LevelId = 1,
                        Points = 95,
                        DateAdded = baseDate.AddDays(-10),
                    }
                );

            // Seed 20 Posts with varying content lengths
            var postContents = new[]
            {
                "Bonjour! Today I want to share my experience learning French. It's been an amazing journey!",
                "Learning a new language opens doors to new cultures and perspectives. I've been studying German for 6 months now and I'm loving every moment of it. The grammar can be challenging, but practice makes perfect!",
                "日本語を勉強しています。とても楽しいです！",
                "English is such a versatile language. Whether you're traveling, working, or just connecting with people from around the world, English skills are invaluable.",
                "Bosanski jezik je predivan! Učim ga već godinu dana i svaki dan otkrivam nešto novo.",
                "French pronunciation can be tricky, but here are some tips that helped me: focus on nasal sounds, practice with native speakers, and don't be afraid to make mistakes!",
                "German compound words are fascinating. Did you know that 'Donaudampfschiffahrtsgesellschaftskapitän' is a real word?",
                "今日は天気がいいですね。",
                "Language learning is not just about memorizing vocabulary. It's about understanding culture, history, and the way people think. When I started learning Japanese, I discovered a whole new way of expressing ideas.",
                "Practice speaking every day, even if it's just for 10 minutes. Consistency is key!",
                "I love how different languages express the same concept differently. In English we say 'I'm hungry', but in French it's 'J'ai faim' which literally means 'I have hunger'. So interesting!",
                "Bosnian grammar has cases, which can be challenging for English speakers. But once you understand the pattern, it becomes much easier.",
                "Watching movies in the target language with subtitles is a great way to improve listening skills. I've been doing this with French films and it's really helping!",
                "Language exchange is amazing. I found a language partner online and we practice speaking twice a week. It's free and very effective!",
                "今日、新しい漢字を学びました。",
                "Don't worry about making mistakes. Every native speaker makes mistakes too. The important thing is to communicate and keep learning. I've been learning German for a year now, and I still make plenty of errors, but I can have conversations and that's what matters!",
                "Reading books in your target language is challenging at first, but it's one of the best ways to expand vocabulary. Start with children's books and work your way up.",
                "French culture is so rich and diverse. Learning the language has given me insights into French history, art, literature, and cuisine. It's like opening a window to a whole new world!",
                "Consistency beats intensity. It's better to study for 20 minutes every day than to cram for 3 hours once a week. I've been following this approach with Japanese and I'm seeing great progress!",
                "Language learning apps are helpful, but nothing beats real conversation. Find opportunities to speak with native speakers, whether online or in person. It's the fastest way to improve!",
            };

            var postTitles = new[]
            {
                "My French Learning Journey",
                "Why I Love Learning German",
                "日本語の勉強",
                "The Power of English",
                "Učenje bosanskog jezika",
                "French Pronunciation Tips",
                "Fascinating German Words",
                "今日の天気",
                "Beyond Vocabulary: Understanding Culture",
                "Daily Practice Matters",
                "Interesting Language Differences",
                "Mastering Bosnian Cases",
                "Learning Through Movies",
                "Language Exchange Benefits",
                "新しい漢字",
                "Don't Fear Mistakes",
                "Reading in Target Language",
                "French Culture Insights",
                "Consistency is Key",
                "Real Conversation Practice",
            };

            var posts = new List<Post>();
            var random = new System.Random(42); // Fixed seed for reproducibility
            // Author IDs: Tutors (2-6), Students (7-11)
            var authorIds = new[]
            {
                2,
                3,
                4,
                5,
                6,
                7,
                8,
                9,
                10,
                11,
                2,
                3,
                4,
                5,
                6,
                7,
                8,
                9,
                10,
                11,
            };

            for (int i = 1; i <= 20; i++)
            {
                posts.Add(
                    new Post
                    {
                        Id = i,
                        Title = postTitles[i - 1],
                        Content = postContents[i - 1],
                        AuthorId = authorIds[i - 1],
                        ImageUrl = string.Empty,
                        CreatedAt = baseDate.AddDays(-random.Next(0, 60)),
                    }
                );
            }

            modelBuilder.Entity<Post>().HasData(posts);

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
        public DbSet<Level> Levels { get; set; }
        public DbSet<Session> Sessions { get; set; }
        public DbSet<Payment> Payments { get; set; }
        public DbSet<StudentLanguage> StudentLanguages { get; set; }
        public DbSet<TutorLanguage> TutorLanguages { get; set; }
        public DbSet<StudentTutorSession> StudentTutorSessions { get; set; }
        public DbSet<Certificate> Certificates { get; set; }
    }
}
