using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace Services.Migrations
{
    /// <inheritdoc />
    public partial class ImageAdded : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Sessions_LanguageLevels_LevelId",
                table: "Sessions"
            );

            migrationBuilder.DropForeignKey(
                name: "FK_StudentLanguages_LanguageLevels_LevelId",
                table: "StudentLanguages"
            );

            migrationBuilder.DropForeignKey(
                name: "FK_StudentTutorSessions_LanguageLevels_LevelId",
                table: "StudentTutorSessions"
            );

            migrationBuilder.DropForeignKey(
                name: "FK_TutorLanguages_LanguageLevels_LevelId",
                table: "TutorLanguages"
            );

            migrationBuilder.DropTable(name: "LanguageLevels");

            migrationBuilder.AddColumn<string>(
                name: "Bio",
                table: "Users",
                type: "nvarchar(max)",
                nullable: true
            );

            migrationBuilder.AddColumn<string>(
                name: "ImageUrl",
                table: "Users",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: ""
            );

            migrationBuilder.AddColumn<int>(
                name: "LanguageId",
                table: "Certificates",
                type: "int",
                nullable: false,
                defaultValue: 0
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
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Levels", x => x.Id);
                }
            );

            migrationBuilder.InsertData(
                table: "Levels",
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

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 1,
                columns: new[] { "CreatedAt", "ImageUrl" },
                values: new object[]
                {
                    new DateTime(2025, 8, 27, 15, 31, 53, 337, DateTimeKind.Utc).AddTicks(4938),
                    "",
                }
            );

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 2,
                columns: new[] { "Bio", "CreatedAt", "ImageUrl" },
                values: new object[]
                {
                    "",
                    new DateTime(2025, 8, 27, 15, 31, 53, 337, DateTimeKind.Utc).AddTicks(4975),
                    "",
                }
            );

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 3,
                columns: new[] { "Bio", "CreatedAt", "ImageUrl" },
                values: new object[]
                {
                    "",
                    new DateTime(2025, 8, 27, 15, 31, 53, 337, DateTimeKind.Utc).AddTicks(4979),
                    "",
                }
            );

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 4,
                columns: new[] { "CreatedAt", "ImageUrl" },
                values: new object[]
                {
                    new DateTime(2025, 8, 27, 15, 31, 53, 337, DateTimeKind.Utc).AddTicks(5014),
                    "",
                }
            );

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 5,
                columns: new[] { "CreatedAt", "ImageUrl" },
                values: new object[]
                {
                    new DateTime(2025, 8, 27, 15, 31, 53, 337, DateTimeKind.Utc).AddTicks(5018),
                    "",
                }
            );

            migrationBuilder.CreateIndex(
                name: "IX_Certificates_LanguageId",
                table: "Certificates",
                column: "LanguageId"
            );

            migrationBuilder.AddForeignKey(
                name: "FK_Certificates_Languages_LanguageId",
                table: "Certificates",
                column: "LanguageId",
                principalTable: "Languages",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade
            );

            migrationBuilder.AddForeignKey(
                name: "FK_Sessions_Levels_LevelId",
                table: "Sessions",
                column: "LevelId",
                principalTable: "Levels",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade
            );

            migrationBuilder.AddForeignKey(
                name: "FK_StudentLanguages_Levels_LevelId",
                table: "StudentLanguages",
                column: "LevelId",
                principalTable: "Levels",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade
            );

            migrationBuilder.AddForeignKey(
                name: "FK_StudentTutorSessions_Levels_LevelId",
                table: "StudentTutorSessions",
                column: "LevelId",
                principalTable: "Levels",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade
            );

            migrationBuilder.AddForeignKey(
                name: "FK_TutorLanguages_Levels_LevelId",
                table: "TutorLanguages",
                column: "LevelId",
                principalTable: "Levels",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade
            );
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Certificates_Languages_LanguageId",
                table: "Certificates"
            );

            migrationBuilder.DropForeignKey(name: "FK_Sessions_Levels_LevelId", table: "Sessions");

            migrationBuilder.DropForeignKey(
                name: "FK_StudentLanguages_Levels_LevelId",
                table: "StudentLanguages"
            );

            migrationBuilder.DropForeignKey(
                name: "FK_StudentTutorSessions_Levels_LevelId",
                table: "StudentTutorSessions"
            );

            migrationBuilder.DropForeignKey(
                name: "FK_TutorLanguages_Levels_LevelId",
                table: "TutorLanguages"
            );

            migrationBuilder.DropTable(name: "Levels");

            migrationBuilder.DropIndex(name: "IX_Certificates_LanguageId", table: "Certificates");

            migrationBuilder.DropColumn(name: "Bio", table: "Users");

            migrationBuilder.DropColumn(name: "ImageUrl", table: "Users");

            migrationBuilder.DropColumn(name: "LanguageId", table: "Certificates");

            migrationBuilder.CreateTable(
                name: "LanguageLevels",
                columns: table => new
                {
                    Id = table
                        .Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Description = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    MaxPoints = table.Column<int>(type: "int", nullable: false),
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: false),
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_LanguageLevels", x => x.Id);
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

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 1,
                column: "CreatedAt",
                value: new DateTime(2025, 8, 10, 17, 2, 44, 93, DateTimeKind.Utc).AddTicks(6337)
            );

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 2,
                column: "CreatedAt",
                value: new DateTime(2025, 8, 10, 17, 2, 44, 93, DateTimeKind.Utc).AddTicks(6384)
            );

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 3,
                column: "CreatedAt",
                value: new DateTime(2025, 8, 10, 17, 2, 44, 93, DateTimeKind.Utc).AddTicks(6388)
            );

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 4,
                column: "CreatedAt",
                value: new DateTime(2025, 8, 10, 17, 2, 44, 93, DateTimeKind.Utc).AddTicks(6426)
            );

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 5,
                column: "CreatedAt",
                value: new DateTime(2025, 8, 10, 17, 2, 44, 93, DateTimeKind.Utc).AddTicks(6430)
            );

            migrationBuilder.AddForeignKey(
                name: "FK_Sessions_LanguageLevels_LevelId",
                table: "Sessions",
                column: "LevelId",
                principalTable: "LanguageLevels",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade
            );

            migrationBuilder.AddForeignKey(
                name: "FK_StudentLanguages_LanguageLevels_LevelId",
                table: "StudentLanguages",
                column: "LevelId",
                principalTable: "LanguageLevels",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade
            );

            migrationBuilder.AddForeignKey(
                name: "FK_StudentTutorSessions_LanguageLevels_LevelId",
                table: "StudentTutorSessions",
                column: "LevelId",
                principalTable: "LanguageLevels",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade
            );

            migrationBuilder.AddForeignKey(
                name: "FK_TutorLanguages_LanguageLevels_LevelId",
                table: "TutorLanguages",
                column: "LevelId",
                principalTable: "LanguageLevels",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade
            );
        }
    }
}
