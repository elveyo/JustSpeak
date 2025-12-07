using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace Services.Migrations
{
    /// <inheritdoc />
    public partial class InitMigration : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Languages",
                columns: table => new
                {
                    Id = table
                        .Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: false),
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Languages", x => x.Id);
                }
            );

            migrationBuilder.CreateTable(
                name: "Levels",
                columns: table => new
                {
                    Id = table
                        .Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Description = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    MaxPoints = table.Column<int>(type: "int", nullable: false),
                    Order = table.Column<int>(type: "int", nullable: false),
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Levels", x => x.Id);
                }
            );

            migrationBuilder.CreateTable(
                name: "Roles",
                columns: table => new
                {
                    Id = table
                        .Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: false),
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Roles", x => x.Id);
                }
            );

            migrationBuilder.CreateTable(
                name: "Tags",
                columns: table => new
                {
                    Id = table
                        .Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Color = table.Column<string>(type: "nvarchar(max)", nullable: false),
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Tags", x => x.Id);
                }
            );

            migrationBuilder.CreateTable(
                name: "Users",
                columns: table => new
                {
                    Id = table
                        .Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    FirstName = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    LastName = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Email = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    ImageUrl = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Bio = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    PasswordHash = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    PasswordSalt = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    Discriminator = table.Column<string>(type: "nvarchar(max)", nullable: false),
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Users", x => x.Id);
                }
            );

            migrationBuilder.CreateTable(
                name: "Sessions",
                columns: table => new
                {
                    Id = table
                        .Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    LanguageId = table.Column<int>(type: "int", nullable: false),
                    LevelId = table.Column<int>(type: "int", nullable: false),
                    Duration = table.Column<int>(type: "int", nullable: false),
                    ChannelName = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    NumOfUsers = table.Column<int>(type: "int", nullable: false),
                    CurrentNumOfUSers = table.Column<int>(type: "int", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Sessions", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Sessions_Languages_LanguageId",
                        column: x => x.LanguageId,
                        principalTable: "Languages",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade
                    );
                    table.ForeignKey(
                        name: "FK_Sessions_Levels_LevelId",
                        column: x => x.LevelId,
                        principalTable: "Levels",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade
                    );
                }
            );

            migrationBuilder.CreateTable(
                name: "Certificates",
                columns: table => new
                {
                    Id = table
                        .Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    ImageUrl = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    TutorId = table.Column<int>(type: "int", nullable: false),
                    LanguageId = table.Column<int>(type: "int", nullable: false),
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Certificates", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Certificates_Languages_LanguageId",
                        column: x => x.LanguageId,
                        principalTable: "Languages",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict
                    );
                    table.ForeignKey(
                        name: "FK_Certificates_Users_TutorId",
                        column: x => x.TutorId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict
                    );
                }
            );

            migrationBuilder.CreateTable(
                name: "Posts",
                columns: table => new
                {
                    Id = table
                        .Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Title = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Content = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    AuthorId = table.Column<int>(type: "int", nullable: false),
                    ImageUrl = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Posts", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Posts_Users_AuthorId",
                        column: x => x.AuthorId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade
                    );
                }
            );

            migrationBuilder.CreateTable(
                name: "Schedules",
                columns: table => new
                {
                    Id = table
                        .Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    TutorId = table.Column<int>(type: "int", nullable: false),
                    Duration = table.Column<int>(type: "int", nullable: false),
                    Price = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Schedules", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Schedules_Users_TutorId",
                        column: x => x.TutorId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict
                    );
                }
            );

            migrationBuilder.CreateTable(
                name: "StudentLanguages",
                columns: table => new
                {
                    Id = table
                        .Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    StudentId = table.Column<int>(type: "int", nullable: false),
                    LanguageId = table.Column<int>(type: "int", nullable: false),
                    LevelId = table.Column<int>(type: "int", nullable: false),
                    Points = table.Column<int>(type: "int", nullable: false),
                    DateAdded = table.Column<DateTime>(type: "datetime2", nullable: false),
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_StudentLanguages", x => x.Id);
                    table.ForeignKey(
                        name: "FK_StudentLanguages_Languages_LanguageId",
                        column: x => x.LanguageId,
                        principalTable: "Languages",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade
                    );
                    table.ForeignKey(
                        name: "FK_StudentLanguages_Levels_LevelId",
                        column: x => x.LevelId,
                        principalTable: "Levels",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade
                    );
                    table.ForeignKey(
                        name: "FK_StudentLanguages_Users_StudentId",
                        column: x => x.StudentId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade
                    );
                }
            );

            migrationBuilder.CreateTable(
                name: "StudentTutorSessions",
                columns: table => new
                {
                    Id = table
                        .Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    StudentId = table.Column<int>(type: "int", nullable: false),
                    LanguageId = table.Column<int>(type: "int", nullable: false),
                    LevelId = table.Column<int>(type: "int", nullable: false),
                    TutorId = table.Column<int>(type: "int", nullable: false),
                    StartTime = table.Column<DateTime>(type: "datetime2", nullable: false),
                    EndTime = table.Column<DateTime>(type: "datetime2", nullable: false),
                    IsActive = table.Column<bool>(type: "bit", nullable: false),
                    Notes = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Rating = table.Column<int>(type: "int", nullable: true),
                    channelName = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_StudentTutorSessions", x => x.Id);
                    table.ForeignKey(
                        name: "FK_StudentTutorSessions_Languages_LanguageId",
                        column: x => x.LanguageId,
                        principalTable: "Languages",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict
                    );
                    table.ForeignKey(
                        name: "FK_StudentTutorSessions_Levels_LevelId",
                        column: x => x.LevelId,
                        principalTable: "Levels",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict
                    );
                    table.ForeignKey(
                        name: "FK_StudentTutorSessions_Users_StudentId",
                        column: x => x.StudentId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict
                    );
                    table.ForeignKey(
                        name: "FK_StudentTutorSessions_Users_TutorId",
                        column: x => x.TutorId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict
                    );
                }
            );

            migrationBuilder.CreateTable(
                name: "TutorLanguages",
                columns: table => new
                {
                    Id = table
                        .Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    TutorId = table.Column<int>(type: "int", nullable: false),
                    LanguageId = table.Column<int>(type: "int", nullable: false),
                    LevelId = table.Column<int>(type: "int", nullable: false),
                    Experience = table.Column<int>(type: "int", nullable: false),
                    PricePerHour = table.Column<int>(type: "int", nullable: false),
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_TutorLanguages", x => x.Id);
                    table.ForeignKey(
                        name: "FK_TutorLanguages_Languages_LanguageId",
                        column: x => x.LanguageId,
                        principalTable: "Languages",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade
                    );
                    table.ForeignKey(
                        name: "FK_TutorLanguages_Levels_LevelId",
                        column: x => x.LevelId,
                        principalTable: "Levels",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade
                    );
                    table.ForeignKey(
                        name: "FK_TutorLanguages_Users_TutorId",
                        column: x => x.TutorId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade
                    );
                }
            );

            migrationBuilder.CreateTable(
                name: "SessionTag",
                columns: table => new
                {
                    SessionsId = table.Column<int>(type: "int", nullable: false),
                    TagsId = table.Column<int>(type: "int", nullable: false),
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_SessionTag", x => new { x.SessionsId, x.TagsId });
                    table.ForeignKey(
                        name: "FK_SessionTag_Sessions_SessionsId",
                        column: x => x.SessionsId,
                        principalTable: "Sessions",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade
                    );
                    table.ForeignKey(
                        name: "FK_SessionTag_Tags_TagsId",
                        column: x => x.TagsId,
                        principalTable: "Tags",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade
                    );
                }
            );

            migrationBuilder.CreateTable(
                name: "Comments",
                columns: table => new
                {
                    Id = table
                        .Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Content = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    PostId = table.Column<int>(type: "int", nullable: false),
                    AuthorId = table.Column<int>(type: "int", nullable: false),
                    ParentCommentId = table.Column<int>(type: "int", nullable: true),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Comments", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Comments_Comments_ParentCommentId",
                        column: x => x.ParentCommentId,
                        principalTable: "Comments",
                        principalColumn: "Id"
                    );
                    table.ForeignKey(
                        name: "FK_Comments_Posts_PostId",
                        column: x => x.PostId,
                        principalTable: "Posts",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict
                    );
                    table.ForeignKey(
                        name: "FK_Comments_Users_AuthorId",
                        column: x => x.AuthorId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict
                    );
                }
            );

            migrationBuilder.CreateTable(
                name: "AvailableDays",
                columns: table => new
                {
                    Id = table
                        .Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    TutorScheduleId = table.Column<int>(type: "int", nullable: false),
                    DayOfWeek = table.Column<int>(type: "int", nullable: false),
                    StartTime = table.Column<TimeSpan>(type: "time", nullable: false),
                    EndTime = table.Column<TimeSpan>(type: "time", nullable: false),
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AvailableDays", x => x.Id);
                    table.ForeignKey(
                        name: "FK_AvailableDays_Schedules_TutorScheduleId",
                        column: x => x.TutorScheduleId,
                        principalTable: "Schedules",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade
                    );
                }
            );

            migrationBuilder.CreateTable(
                name: "Payments",
                columns: table => new
                {
                    Id = table
                        .Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    SessionId = table.Column<int>(type: "int", nullable: false),
                    Amount = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    Status = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    StripeTransactionId = table.Column<string>(
                        type: "nvarchar(max)",
                        nullable: false
                    ),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Payments", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Payments_StudentTutorSessions_SessionId",
                        column: x => x.SessionId,
                        principalTable: "StudentTutorSessions",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade
                    );
                }
            );

            migrationBuilder.CreateTable(
                name: "Likes",
                columns: table => new
                {
                    Id = table
                        .Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UserId = table.Column<int>(type: "int", nullable: false),
                    PostId = table.Column<int>(type: "int", nullable: true),
                    CommentId = table.Column<int>(type: "int", nullable: true),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Likes", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Likes_Comments_CommentId",
                        column: x => x.CommentId,
                        principalTable: "Comments",
                        principalColumn: "Id"
                    );
                    table.ForeignKey(
                        name: "FK_Likes_Posts_PostId",
                        column: x => x.PostId,
                        principalTable: "Posts",
                        principalColumn: "Id"
                    );
                    table.ForeignKey(
                        name: "FK_Likes_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade
                    );
                }
            );

            migrationBuilder.InsertData(
                table: "Languages",
                columns: new[] { "Id", "Name" },
                values: new object[,]
                {
                    { 1, "English" },
                    { 2, "Bosnian" },
                    { 3, "French" },
                    { 4, "German" },
                    { 5, "Japanese" },
                }
            );

            migrationBuilder.InsertData(
                table: "Levels",
                columns: new[] { "Id", "Description", "MaxPoints", "Name", "Order" },
                values: new object[,]
                {
                    {
                        1,
                        "Embarking on the language journey, learning greetings and essential words.",
                        100,
                        "Wanderer",
                        1,
                    },
                    {
                        2,
                        "Navigating simple conversations and discovering basic grammar structures.",
                        200,
                        "Explorer",
                        2,
                    },
                    {
                        3,
                        "Confidently sharing stories and engaging in daily discussions.",
                        400,
                        "Storyteller",
                        3,
                    },
                    {
                        4,
                        "Mastering complex topics, idioms, and nuanced expressions.",
                        600,
                        "Sage",
                        4,
                    },
                    {
                        5,
                        "Achieving legendary fluency and cultural mastery, speaking like a native.",
                        1000,
                        "Polyglot",
                        5,
                    },
                }
            );

            migrationBuilder.InsertData(
                table: "Tags",
                columns: new[] { "Id", "Color", "Name" },
                values: new object[,]
                {
                    { 1, "#4CAF50", "Conversation" },
                    { 2, "#2196F3", "Grammar" },
                    { 3, "#FF9800", "Pronunciation" },
                    { 4, "#9C27B0", "Travel" },
                    { 5, "#FF5722", "Food & Cooking" },
                    { 6, "#607D8B", "Business" },
                    { 7, "#E91E63", "Culture" },
                    { 8, "#795548", "Daily Life" },
                    { 9, "#00BCD4", "Hobbies" },
                    { 10, "#8BC34A", "Health & Wellness" },
                }
            );

            migrationBuilder.InsertData(
                table: "Users",
                columns: new[]
                {
                    "Id",
                    "Bio",
                    "CreatedAt",
                    "Discriminator",
                    "Email",
                    "FirstName",
                    "ImageUrl",
                    "LastName",
                    "PasswordHash",
                    "PasswordSalt",
                },
                values: new object[,]
                {
                    {
                        1,
                        null,
                        new DateTime(2025, 11, 23, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259),
                        "Admin",
                        "admin@justspeak.com",
                        "Admin",
                        null,
                        "User",
                        "FwwLVIQL84DVKossXEHd0t7yQCaQDGlkEKcND+nsCEQ=",
                        "vew6OzACMpTcQjQiOQEgEQ==",
                    },
                    {
                        2,
                        null,
                        new DateTime(2025, 11, 23, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259),
                        "Tutor",
                        "sarah.johnson@justspeak.com",
                        "Sarah",
                        null,
                        "Johnson",
                        "FwwLVIQL84DVKossXEHd0t7yQCaQDGlkEKcND+nsCEQ=",
                        "vew6OzACMpTcQjQiOQEgEQ==",
                    },
                    {
                        3,
                        null,
                        new DateTime(2025, 11, 23, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259),
                        "Tutor",
                        "michael.chen@justspeak.com",
                        "Michael",
                        null,
                        "Chen",
                        "FwwLVIQL84DVKossXEHd0t7yQCaQDGlkEKcND+nsCEQ=",
                        "vew6OzACMpTcQjQiOQEgEQ==",
                    },
                    {
                        4,
                        null,
                        new DateTime(2025, 11, 23, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259),
                        "Tutor",
                        "emma.williams@justspeak.com",
                        "Emma",
                        null,
                        "Williams",
                        "FwwLVIQL84DVKossXEHd0t7yQCaQDGlkEKcND+nsCEQ=",
                        "vew6OzACMpTcQjQiOQEgEQ==",
                    },
                    {
                        5,
                        null,
                        new DateTime(2025, 11, 23, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259),
                        "Tutor",
                        "david.martinez@justspeak.com",
                        "David",
                        null,
                        "Martinez",
                        "FwwLVIQL84DVKossXEHd0t7yQCaQDGlkEKcND+nsCEQ=",
                        "vew6OzACMpTcQjQiOQEgEQ==",
                    },
                    {
                        6,
                        null,
                        new DateTime(2025, 11, 23, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259),
                        "Tutor",
                        "lisa.anderson@justspeak.com",
                        "Lisa",
                        null,
                        "Anderson",
                        "FwwLVIQL84DVKossXEHd0t7yQCaQDGlkEKcND+nsCEQ=",
                        "vew6OzACMpTcQjQiOQEgEQ==",
                    },
                    {
                        7,
                        null,
                        new DateTime(2025, 11, 23, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259),
                        "Student",
                        "james.brown@justspeak.com",
                        "James",
                        null,
                        "Brown",
                        "FwwLVIQL84DVKossXEHd0t7yQCaQDGlkEKcND+nsCEQ=",
                        "vew6OzACMpTcQjQiOQEgEQ==",
                    },
                    {
                        8,
                        null,
                        new DateTime(2025, 11, 23, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259),
                        "Student",
                        "maria.garcia@justspeak.com",
                        "Maria",
                        null,
                        "Garcia",
                        "FwwLVIQL84DVKossXEHd0t7yQCaQDGlkEKcND+nsCEQ=",
                        "vew6OzACMpTcQjQiOQEgEQ==",
                    },
                    {
                        9,
                        null,
                        new DateTime(2025, 11, 23, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259),
                        "Student",
                        "robert.taylor@justspeak.com",
                        "Robert",
                        null,
                        "Taylor",
                        "FwwLVIQL84DVKossXEHd0t7yQCaQDGlkEKcND+nsCEQ=",
                        "vew6OzACMpTcQjQiOQEgEQ==",
                    },
                    {
                        10,
                        null,
                        new DateTime(2025, 11, 23, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259),
                        "Student",
                        "jennifer.davis@justspeak.com",
                        "Jennifer",
                        null,
                        "Davis",
                        "FwwLVIQL84DVKossXEHd0t7yQCaQDGlkEKcND+nsCEQ=",
                        "vew6OzACMpTcQjQiOQEgEQ==",
                    },
                    {
                        11,
                        null,
                        new DateTime(2025, 11, 23, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259),
                        "Student",
                        "william.wilson@justspeak.com",
                        "William",
                        null,
                        "Wilson",
                        "FwwLVIQL84DVKossXEHd0t7yQCaQDGlkEKcND+nsCEQ=",
                        "vew6OzACMpTcQjQiOQEgEQ==",
                    },
                }
            );

            migrationBuilder.InsertData(
                table: "Posts",
                columns: new[] { "Id", "AuthorId", "Content", "CreatedAt", "ImageUrl", "Title" },
                values: new object[,]
                {
                    {
                        1,
                        2,
                        "Bonjour! Today I want to share my experience learning French. It's been an amazing journey!",
                        new DateTime(2025, 10, 14, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259),
                        "",
                        "My French Learning Journey",
                    },
                    {
                        2,
                        3,
                        "Learning a new language opens doors to new cultures and perspectives. I've been studying German for 6 months now and I'm loving every moment of it. The grammar can be challenging, but practice makes perfect!",
                        new DateTime(2025, 11, 15, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259),
                        "",
                        "Why I Love Learning German",
                    },
                    {
                        3,
                        4,
                        "日本語を勉強しています。とても楽しいです！",
                        new DateTime(2025, 11, 16, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259),
                        "",
                        "日本語の勉強",
                    },
                    {
                        4,
                        5,
                        "English is such a versatile language. Whether you're traveling, working, or just connecting with people from around the world, English skills are invaluable.",
                        new DateTime(2025, 10, 23, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259),
                        "",
                        "The Power of English",
                    },
                    {
                        5,
                        6,
                        "Bosanski jezik je predivan! Učim ga već godinu dana i svaki dan otkrivam nešto novo.",
                        new DateTime(2025, 11, 13, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259),
                        "",
                        "Učenje bosanskog jezika",
                    },
                    {
                        6,
                        7,
                        "French pronunciation can be tricky, but here are some tips that helped me: focus on nasal sounds, practice with native speakers, and don't be afraid to make mistakes!",
                        new DateTime(2025, 11, 8, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259),
                        "",
                        "French Pronunciation Tips",
                    },
                    {
                        7,
                        8,
                        "German compound words are fascinating. Did you know that 'Donaudampfschiffahrtsgesellschaftskapitän' is a real word?",
                        new DateTime(2025, 10, 11, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259),
                        "",
                        "Fascinating German Words",
                    },
                    {
                        8,
                        9,
                        "今日は天気がいいですね。",
                        new DateTime(2025, 10, 24, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259),
                        "",
                        "今日の天気",
                    },
                    {
                        9,
                        10,
                        "Language learning is not just about memorizing vocabulary. It's about understanding culture, history, and the way people think. When I started learning Japanese, I discovered a whole new way of expressing ideas.",
                        new DateTime(2025, 11, 13, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259),
                        "",
                        "Beyond Vocabulary: Understanding Culture",
                    },
                    {
                        10,
                        11,
                        "Practice speaking every day, even if it's just for 10 minutes. Consistency is key!",
                        new DateTime(2025, 10, 9, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259),
                        "",
                        "Daily Practice Matters",
                    },
                    {
                        11,
                        2,
                        "I love how different languages express the same concept differently. In English we say 'I'm hungry', but in French it's 'J'ai faim' which literally means 'I have hunger'. So interesting!",
                        new DateTime(2025, 11, 9, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259),
                        "",
                        "Interesting Language Differences",
                    },
                    {
                        12,
                        3,
                        "Bosnian grammar has cases, which can be challenging for English speakers. But once you understand the pattern, it becomes much easier.",
                        new DateTime(2025, 11, 8, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259),
                        "",
                        "Mastering Bosnian Cases",
                    },
                    {
                        13,
                        4,
                        "Watching movies in the target language with subtitles is a great way to improve listening skills. I've been doing this with French films and it's really helping!",
                        new DateTime(2025, 10, 24, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259),
                        "",
                        "Learning Through Movies",
                    },
                    {
                        14,
                        5,
                        "Language exchange is amazing. I found a language partner online and we practice speaking twice a week. It's free and very effective!",
                        new DateTime(2025, 11, 4, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259),
                        "",
                        "Language Exchange Benefits",
                    },
                    {
                        15,
                        6,
                        "今日、新しい漢字を学びました。",
                        new DateTime(2025, 11, 1, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259),
                        "",
                        "新しい漢字",
                    },
                    {
                        16,
                        7,
                        "Don't worry about making mistakes. Every native speaker makes mistakes too. The important thing is to communicate and keep learning. I've been learning German for a year now, and I still make plenty of errors, but I can have conversations and that's what matters!",
                        new DateTime(2025, 11, 8, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259),
                        "",
                        "Don't Fear Mistakes",
                    },
                    {
                        17,
                        8,
                        "Reading books in your target language is challenging at first, but it's one of the best ways to expand vocabulary. Start with children's books and work your way up.",
                        new DateTime(2025, 10, 23, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259),
                        "",
                        "Reading in Target Language",
                    },
                    {
                        18,
                        9,
                        "French culture is so rich and diverse. Learning the language has given me insights into French history, art, literature, and cuisine. It's like opening a window to a whole new world!",
                        new DateTime(2025, 11, 21, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259),
                        "",
                        "French Culture Insights",
                    },
                    {
                        19,
                        10,
                        "Consistency beats intensity. It's better to study for 20 minutes every day than to cram for 3 hours once a week. I've been following this approach with Japanese and I'm seeing great progress!",
                        new DateTime(2025, 10, 6, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259),
                        "",
                        "Consistency is Key",
                    },
                    {
                        20,
                        11,
                        "Language learning apps are helpful, but nothing beats real conversation. Find opportunities to speak with native speakers, whether online or in person. It's the fastest way to improve!",
                        new DateTime(2025, 10, 20, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259),
                        "",
                        "Real Conversation Practice",
                    },
                }
            );

            migrationBuilder.InsertData(
                table: "StudentLanguages",
                columns: new[]
                {
                    "Id",
                    "DateAdded",
                    "LanguageId",
                    "LevelId",
                    "Points",
                    "StudentId",
                },
                values: new object[,]
                {
                    {
                        1,
                        new DateTime(2025, 10, 24, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259),
                        1,
                        2,
                        75,
                        7,
                    },
                    {
                        2,
                        new DateTime(2025, 11, 8, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259),
                        3,
                        1,
                        45,
                        7,
                    },
                    {
                        3,
                        new DateTime(2025, 9, 24, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259),
                        4,
                        3,
                        320,
                        8,
                    },
                    {
                        4,
                        new DateTime(2025, 11, 3, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259),
                        5,
                        1,
                        85,
                        8,
                    },
                    {
                        5,
                        new DateTime(2025, 8, 25, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259),
                        2,
                        4,
                        550,
                        9,
                    },
                    {
                        6,
                        new DateTime(2025, 10, 9, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259),
                        1,
                        2,
                        120,
                        9,
                    },
                    {
                        7,
                        new DateTime(2025, 10, 29, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259),
                        3,
                        1,
                        60,
                        10,
                    },
                    {
                        8,
                        new DateTime(2025, 10, 4, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259),
                        4,
                        2,
                        180,
                        10,
                    },
                    {
                        9,
                        new DateTime(2025, 9, 9, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259),
                        5,
                        3,
                        380,
                        11,
                    },
                    {
                        10,
                        new DateTime(2025, 11, 13, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259),
                        2,
                        1,
                        95,
                        11,
                    },
                }
            );

            migrationBuilder.InsertData(
                table: "TutorLanguages",
                columns: new[]
                {
                    "Id",
                    "Experience",
                    "LanguageId",
                    "LevelId",
                    "PricePerHour",
                    "TutorId",
                },
                values: new object[,]
                {
                    { 1, 10, 1, 5, 35, 2 },
                    { 2, 8, 3, 4, 30, 2 },
                    { 3, 15, 5, 5, 40, 3 },
                    { 4, 12, 1, 4, 35, 3 },
                    { 5, 9, 4, 5, 32, 4 },
                    { 6, 11, 2, 5, 28, 4 },
                    { 7, 7, 3, 5, 30, 5 },
                    { 8, 6, 1, 5, 28, 5 },
                    { 9, 8, 5, 4, 38, 6 },
                    { 10, 10, 2, 5, 25, 6 },
                }
            );

            migrationBuilder.CreateIndex(
                name: "IX_AvailableDays_TutorScheduleId",
                table: "AvailableDays",
                column: "TutorScheduleId"
            );

            migrationBuilder.CreateIndex(
                name: "IX_Certificates_LanguageId",
                table: "Certificates",
                column: "LanguageId"
            );

            migrationBuilder.CreateIndex(
                name: "IX_Certificates_TutorId",
                table: "Certificates",
                column: "TutorId"
            );

            migrationBuilder.CreateIndex(
                name: "IX_Comments_AuthorId",
                table: "Comments",
                column: "AuthorId"
            );

            migrationBuilder.CreateIndex(
                name: "IX_Comments_ParentCommentId",
                table: "Comments",
                column: "ParentCommentId"
            );

            migrationBuilder.CreateIndex(
                name: "IX_Comments_PostId",
                table: "Comments",
                column: "PostId"
            );

            migrationBuilder.CreateIndex(
                name: "IX_Like_User_Comment",
                table: "Likes",
                columns: new[] { "UserId", "CommentId" },
                unique: true,
                filter: "[CommentId] IS NOT NULL"
            );

            migrationBuilder.CreateIndex(
                name: "IX_Like_User_Post",
                table: "Likes",
                columns: new[] { "UserId", "PostId" },
                unique: true,
                filter: "[PostId] IS NOT NULL"
            );

            migrationBuilder.CreateIndex(
                name: "IX_Likes_CommentId",
                table: "Likes",
                column: "CommentId"
            );

            migrationBuilder.CreateIndex(name: "IX_Likes_PostId", table: "Likes", column: "PostId");

            migrationBuilder.CreateIndex(
                name: "IX_Payments_SessionId",
                table: "Payments",
                column: "SessionId"
            );

            migrationBuilder.CreateIndex(
                name: "IX_Posts_AuthorId",
                table: "Posts",
                column: "AuthorId"
            );

            migrationBuilder.CreateIndex(
                name: "IX_Schedules_TutorId",
                table: "Schedules",
                column: "TutorId"
            );

            migrationBuilder.CreateIndex(
                name: "IX_Sessions_LanguageId",
                table: "Sessions",
                column: "LanguageId"
            );

            migrationBuilder.CreateIndex(
                name: "IX_Sessions_LevelId",
                table: "Sessions",
                column: "LevelId"
            );

            migrationBuilder.CreateIndex(
                name: "IX_SessionTag_TagsId",
                table: "SessionTag",
                column: "TagsId"
            );

            migrationBuilder.CreateIndex(
                name: "IX_StudentLanguages_LanguageId",
                table: "StudentLanguages",
                column: "LanguageId"
            );

            migrationBuilder.CreateIndex(
                name: "IX_StudentLanguages_LevelId",
                table: "StudentLanguages",
                column: "LevelId"
            );

            migrationBuilder.CreateIndex(
                name: "IX_StudentLanguages_StudentId",
                table: "StudentLanguages",
                column: "StudentId"
            );

            migrationBuilder.CreateIndex(
                name: "IX_StudentTutorSessions_LanguageId",
                table: "StudentTutorSessions",
                column: "LanguageId"
            );

            migrationBuilder.CreateIndex(
                name: "IX_StudentTutorSessions_LevelId",
                table: "StudentTutorSessions",
                column: "LevelId"
            );

            migrationBuilder.CreateIndex(
                name: "IX_StudentTutorSessions_StudentId",
                table: "StudentTutorSessions",
                column: "StudentId"
            );

            migrationBuilder.CreateIndex(
                name: "IX_StudentTutorSessions_TutorId",
                table: "StudentTutorSessions",
                column: "TutorId"
            );

            migrationBuilder.CreateIndex(
                name: "IX_TutorLanguages_LanguageId",
                table: "TutorLanguages",
                column: "LanguageId"
            );

            migrationBuilder.CreateIndex(
                name: "IX_TutorLanguages_LevelId",
                table: "TutorLanguages",
                column: "LevelId"
            );

            migrationBuilder.CreateIndex(
                name: "IX_TutorLanguages_TutorId",
                table: "TutorLanguages",
                column: "TutorId"
            );
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(name: "AvailableDays");

            migrationBuilder.DropTable(name: "Certificates");

            migrationBuilder.DropTable(name: "Likes");

            migrationBuilder.DropTable(name: "Payments");

            migrationBuilder.DropTable(name: "Roles");

            migrationBuilder.DropTable(name: "SessionTag");

            migrationBuilder.DropTable(name: "StudentLanguages");

            migrationBuilder.DropTable(name: "TutorLanguages");

            migrationBuilder.DropTable(name: "Schedules");

            migrationBuilder.DropTable(name: "Comments");

            migrationBuilder.DropTable(name: "StudentTutorSessions");

            migrationBuilder.DropTable(name: "Sessions");

            migrationBuilder.DropTable(name: "Tags");

            migrationBuilder.DropTable(name: "Posts");

            migrationBuilder.DropTable(name: "Languages");

            migrationBuilder.DropTable(name: "Levels");

            migrationBuilder.DropTable(name: "Users");
        }
    }
}
