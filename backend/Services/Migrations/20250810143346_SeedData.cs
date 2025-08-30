using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace Services.Migrations
{
    /// <inheritdoc />
    public partial class SeedData : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "LanguageLevels",
                columns: table => new
                {
                    Id = table
                        .Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Description = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    MaxPoints = table.Column<int>(type: "int", nullable: false),
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_LanguageLevels", x => x.Id);
                }
            );

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
                name: "Sessions",
                columns: table => new
                {
                    Id = table
                        .Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    NumberOfUsers = table.Column<int>(type: "int", nullable: false),
                    LanguageId = table.Column<int>(type: "int", nullable: false),
                    LevelId = table.Column<int>(type: "int", nullable: false),
                    Duration = table.Column<int>(type: "int", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Sessions", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Sessions_LanguageLevels_LevelId",
                        column: x => x.LevelId,
                        principalTable: "LanguageLevels",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade
                    );
                    table.ForeignKey(
                        name: "FK_Sessions_Languages_LanguageId",
                        column: x => x.LanguageId,
                        principalTable: "Languages",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade
                    );
                }
            );

            migrationBuilder.CreateTable(
                name: "Users",
                columns: table => new
                {
                    Id = table
                        .Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    FirstName = table.Column<string>(
                        type: "nvarchar(50)",
                        maxLength: 50,
                        nullable: false
                    ),
                    LastName = table.Column<string>(
                        type: "nvarchar(50)",
                        maxLength: 50,
                        nullable: false
                    ),
                    Email = table.Column<string>(
                        type: "nvarchar(50)",
                        maxLength: 50,
                        nullable: false
                    ),
                    PasswordHash = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    PasswordSalt = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    IsEmailVerified = table.Column<bool>(type: "bit", nullable: false),
                    IsActive = table.Column<bool>(type: "bit", nullable: false),
                    RoleId = table.Column<int>(type: "int", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    Discriminator = table.Column<string>(type: "nvarchar(max)", nullable: false),
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Users", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Users_Roles_RoleId",
                        column: x => x.RoleId,
                        principalTable: "Roles",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade
                    );
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
                    SessionId = table.Column<int>(type: "int", nullable: true),
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Tags", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Tags_Sessions_SessionId",
                        column: x => x.SessionId,
                        principalTable: "Sessions",
                        principalColumn: "Id"
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
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Certificates", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Certificates_Users_TutorId",
                        column: x => x.TutorId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade
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
                        onDelete: ReferentialAction.Cascade
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
                        name: "FK_StudentLanguages_LanguageLevels_LevelId",
                        column: x => x.LevelId,
                        principalTable: "LanguageLevels",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade
                    );
                    table.ForeignKey(
                        name: "FK_StudentLanguages_Languages_LanguageId",
                        column: x => x.LanguageId,
                        principalTable: "Languages",
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
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_StudentTutorSessions", x => x.Id);
                    table.ForeignKey(
                        name: "FK_StudentTutorSessions_LanguageLevels_LevelId",
                        column: x => x.LevelId,
                        principalTable: "LanguageLevels",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.NoAction
                    );
                    table.ForeignKey(
                        name: "FK_StudentTutorSessions_Languages_LanguageId",
                        column: x => x.LanguageId,
                        principalTable: "Languages",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.NoAction
                    );
                    table.ForeignKey(
                        name: "FK_StudentTutorSessions_Users_StudentId",
                        column: x => x.StudentId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.NoAction
                    );
                    table.ForeignKey(
                        name: "FK_StudentTutorSessions_Users_TutorId",
                        column: x => x.TutorId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.NoAction
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
                        name: "FK_TutorLanguages_LanguageLevels_LevelId",
                        column: x => x.LevelId,
                        principalTable: "LanguageLevels",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade
                    );
                    table.ForeignKey(
                        name: "FK_TutorLanguages_Languages_LanguageId",
                        column: x => x.LanguageId,
                        principalTable: "Languages",
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
                name: "Comments",
                columns: table => new
                {
                    Id = table
                        .Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Content = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    PostId = table.Column<int>(type: "int", nullable: false),
                    AuthorId = table.Column<int>(type: "int", nullable: false),
                    ParentCommentId = table.Column<int>(type: "int", nullable: true),
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Comments", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Comments_Comments_ParentCommentId",
                        column: x => x.ParentCommentId,
                        principalTable: "Comments",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict
                    );
                    table.ForeignKey(
                        name: "FK_Comments_Posts_PostId",
                        column: x => x.PostId,
                        principalTable: "Posts",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade
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
                    StudentId = table.Column<int>(type: "int", nullable: false),
                    TutorId = table.Column<int>(type: "int", nullable: false),
                    SessionId = table.Column<int>(type: "int", nullable: false),
                    Amount = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    PaymentStatus = table.Column<string>(type: "nvarchar(max)", nullable: false),
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
                        onDelete: ReferentialAction.NoAction
                    );
                    table.ForeignKey(
                        name: "FK_Payments_Users_StudentId",
                        column: x => x.StudentId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.NoAction
                    );
                    table.ForeignKey(
                        name: "FK_Payments_Users_TutorId",
                        column: x => x.TutorId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.NoAction
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
                table: "LanguageLevels",
                columns: new[] { "Id", "Description", "MaxPoints", "Name" },
                values: new object[,]
                {
                    {
                        1,
                        "Embarking on the language journey, learning greetings and essential words.",
                        100,
                        "Wanderer",
                    },
                    {
                        2,
                        "Navigating simple conversations and discovering basic grammar structures.",
                        200,
                        "Explorer",
                    },
                    {
                        3,
                        "Confidently sharing stories and engaging in daily discussions.",
                        400,
                        "Storyteller",
                    },
                    {
                        4,
                        "Mastering complex topics, idioms, and nuanced expressions.",
                        600,
                        "Sage",
                    },
                    {
                        5,
                        "Achieving legendary fluency and cultural mastery, speaking like a native.",
                        1000,
                        "Polyglot",
                    },
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
                table: "Roles",
                columns: new[] { "Id", "Name" },
                values: new object[,]
                {
                    { 1, "Admin" },
                    { 2, "Tutor" },
                    { 3, "Student" },
                }
            );

            migrationBuilder.InsertData(
                table: "Users",
                columns: new[]
                {
                    "Id",
                    "CreatedAt",
                    "Discriminator",
                    "Email",
                    "FirstName",
                    "IsActive",
                    "IsEmailVerified",
                    "LastName",
                    "PasswordHash",
                    "PasswordSalt",
                    "RoleId",
                },
                values: new object[,]
                {
                    {
                        1,
                        new DateTime(2025, 8, 10, 14, 33, 45, 734, DateTimeKind.Utc).AddTicks(6475),
                        "Admin",
                        "admin@justspeak.com",
                        "Admin",
                        true,
                        true,
                        "User",
                        "hashed_password",
                        "salt",
                        1,
                    },
                    {
                        2,
                        new DateTime(2025, 8, 10, 14, 33, 45, 734, DateTimeKind.Utc).AddTicks(6517),
                        "Tutor",
                        "maria@justspeak.com",
                        "Maria",
                        true,
                        true,
                        "Garcia",
                        "hashed_password",
                        "salt",
                        2,
                    },
                    {
                        3,
                        new DateTime(2025, 8, 10, 14, 33, 45, 734, DateTimeKind.Utc).AddTicks(6522),
                        "Tutor",
                        "jean@justspeak.com",
                        "Jean",
                        true,
                        true,
                        "Dubois",
                        "hashed_password",
                        "salt",
                        2,
                    },
                    {
                        4,
                        new DateTime(2025, 8, 10, 14, 33, 45, 734, DateTimeKind.Utc).AddTicks(6551),
                        "Student",
                        "hans@justspeak.com",
                        "Hans",
                        true,
                        true,
                        "Muller",
                        "hashed_password",
                        "salt",
                        3,
                    },
                    {
                        5,
                        new DateTime(2025, 8, 10, 14, 33, 45, 734, DateTimeKind.Utc).AddTicks(6555),
                        "Student",
                        "yuki@justspeak.com",
                        "Yuki",
                        true,
                        true,
                        "Tanaka",
                        "hashed_password",
                        "salt",
                        3,
                    },
                }
            );

            migrationBuilder.CreateIndex(
                name: "IX_AvailableDays_TutorScheduleId",
                table: "AvailableDays",
                column: "TutorScheduleId"
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
                name: "IX_Payments_StudentId",
                table: "Payments",
                column: "StudentId"
            );

            migrationBuilder.CreateIndex(
                name: "IX_Payments_TutorId",
                table: "Payments",
                column: "TutorId"
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
                name: "IX_Tags_SessionId",
                table: "Tags",
                column: "SessionId"
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

            migrationBuilder.CreateIndex(name: "IX_Users_RoleId", table: "Users", column: "RoleId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(name: "AvailableDays");

            migrationBuilder.DropTable(name: "Certificates");

            migrationBuilder.DropTable(name: "Likes");

            migrationBuilder.DropTable(name: "Payments");

            migrationBuilder.DropTable(name: "StudentLanguages");

            migrationBuilder.DropTable(name: "Tags");

            migrationBuilder.DropTable(name: "TutorLanguages");

            migrationBuilder.DropTable(name: "Schedules");

            migrationBuilder.DropTable(name: "Comments");

            migrationBuilder.DropTable(name: "StudentTutorSessions");

            migrationBuilder.DropTable(name: "Sessions");

            migrationBuilder.DropTable(name: "Posts");

            migrationBuilder.DropTable(name: "LanguageLevels");

            migrationBuilder.DropTable(name: "Languages");

            migrationBuilder.DropTable(name: "Users");

            migrationBuilder.DropTable(name: "Roles");
        }
    }
}
