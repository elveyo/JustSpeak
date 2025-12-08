using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Services.Migrations
{
    /// <inheritdoc />
    public partial class AddTestUsers : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
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
                    // Admin test user
                    {
                        100,
                        "System administrator for JustSpeak platform",
                        new DateTime(2025, 12, 8, 0, 0, 0, 0, DateTimeKind.Utc),
                        "Admin",
                        "admin@test.com",
                        "Admin",
                        null,
                        "Test",
                        "FwwLVIQL84DVKossXEHd0t7yQCaQDGlkEKcND+nsCEQ=",
                        "vew6OzACMpTcQjQiOQEgEQ==",
                    },
                    // Tutor test user
                    {
                        101,
                        "Experienced language tutor specializing in English and French",
                        new DateTime(2025, 12, 8, 0, 0, 0, 0, DateTimeKind.Utc),
                        "Tutor",
                        "tutor@test.com",
                        "Tutor",
                        null,
                        "Test",
                        "FwwLVIQL84DVKossXEHd0t7yQCaQDGlkEKcND+nsCEQ=",
                        "vew6OzACMpTcQjQiOQEgEQ==",
                    },
                    // Student test user
                    {
                        102,
                        "Passionate language learner eager to improve communication skills",
                        new DateTime(2025, 12, 8, 0, 0, 0, 0, DateTimeKind.Utc),
                        "Student",
                        "student@test.com",
                        "Student",
                        null,
                        "Test",
                        "FwwLVIQL84DVKossXEHd0t7yQCaQDGlkEKcND+nsCEQ=",
                        "vew6OzACMpTcQjQiOQEgEQ==",
                    },
                }
            );

            // Add tutor languages for the test tutor
            migrationBuilder.InsertData(
                table: "TutorLanguages",
                columns: new[] { "Id", "TutorId", "LanguageId", "LevelId", "Experience", "PricePerHour" },
                values: new object[,]
                {
                    { 100, 101, 1, 5, 5, 25 }, // English - Polyglot level
                    { 101, 101, 3, 4, 3, 20 }, // French - Sage level
                }
            );

            // Add student languages for the test student
            migrationBuilder.InsertData(
                table: "StudentLanguages",
                columns: new[] { "Id", "StudentId", "LanguageId", "LevelId", "Points", "DateAdded" },
                values: new object[,]
                {
                    { 100, 102, 1, 2, 50, new DateTime(2025, 12, 8, 0, 0, 0, 0, DateTimeKind.Utc) }, // English - Explorer level
                    { 101, 102, 3, 1, 25, new DateTime(2025, 12, 8, 0, 0, 0, 0, DateTimeKind.Utc) }, // French - Wanderer level
                }
            );

            migrationBuilder.UpdateData(
                table: "Posts",
                keyColumn: "Id",
                keyValue: 1,
                column: "CreatedAt",
                value: new DateTime(2025, 10, 29, 18, 48, 59, 580, DateTimeKind.Utc).AddTicks(3881));

            migrationBuilder.UpdateData(
                table: "Posts",
                keyColumn: "Id",
                keyValue: 2,
                column: "CreatedAt",
                value: new DateTime(2025, 11, 30, 18, 48, 59, 580, DateTimeKind.Utc).AddTicks(3881));

            migrationBuilder.UpdateData(
                table: "Posts",
                keyColumn: "Id",
                keyValue: 3,
                column: "CreatedAt",
                value: new DateTime(2025, 12, 1, 18, 48, 59, 580, DateTimeKind.Utc).AddTicks(3881));

            migrationBuilder.UpdateData(
                table: "Posts",
                keyColumn: "Id",
                keyValue: 4,
                column: "CreatedAt",
                value: new DateTime(2025, 11, 7, 18, 48, 59, 580, DateTimeKind.Utc).AddTicks(3881));

            migrationBuilder.UpdateData(
                table: "Posts",
                keyColumn: "Id",
                keyValue: 5,
                column: "CreatedAt",
                value: new DateTime(2025, 11, 28, 18, 48, 59, 580, DateTimeKind.Utc).AddTicks(3881));

            migrationBuilder.UpdateData(
                table: "Posts",
                keyColumn: "Id",
                keyValue: 6,
                column: "CreatedAt",
                value: new DateTime(2025, 11, 23, 18, 48, 59, 580, DateTimeKind.Utc).AddTicks(3881));

            migrationBuilder.UpdateData(
                table: "Posts",
                keyColumn: "Id",
                keyValue: 7,
                column: "CreatedAt",
                value: new DateTime(2025, 10, 26, 18, 48, 59, 580, DateTimeKind.Utc).AddTicks(3881));

            migrationBuilder.UpdateData(
                table: "Posts",
                keyColumn: "Id",
                keyValue: 8,
                column: "CreatedAt",
                value: new DateTime(2025, 11, 8, 18, 48, 59, 580, DateTimeKind.Utc).AddTicks(3881));

            migrationBuilder.UpdateData(
                table: "Posts",
                keyColumn: "Id",
                keyValue: 9,
                column: "CreatedAt",
                value: new DateTime(2025, 11, 28, 18, 48, 59, 580, DateTimeKind.Utc).AddTicks(3881));

            migrationBuilder.UpdateData(
                table: "Posts",
                keyColumn: "Id",
                keyValue: 10,
                column: "CreatedAt",
                value: new DateTime(2025, 10, 24, 18, 48, 59, 580, DateTimeKind.Utc).AddTicks(3881));

            migrationBuilder.UpdateData(
                table: "Posts",
                keyColumn: "Id",
                keyValue: 11,
                column: "CreatedAt",
                value: new DateTime(2025, 11, 24, 18, 48, 59, 580, DateTimeKind.Utc).AddTicks(3881));

            migrationBuilder.UpdateData(
                table: "Posts",
                keyColumn: "Id",
                keyValue: 12,
                column: "CreatedAt",
                value: new DateTime(2025, 11, 23, 18, 48, 59, 580, DateTimeKind.Utc).AddTicks(3881));

            migrationBuilder.UpdateData(
                table: "Posts",
                keyColumn: "Id",
                keyValue: 13,
                column: "CreatedAt",
                value: new DateTime(2025, 11, 8, 18, 48, 59, 580, DateTimeKind.Utc).AddTicks(3881));

            migrationBuilder.UpdateData(
                table: "Posts",
                keyColumn: "Id",
                keyValue: 14,
                column: "CreatedAt",
                value: new DateTime(2025, 11, 19, 18, 48, 59, 580, DateTimeKind.Utc).AddTicks(3881));

            migrationBuilder.UpdateData(
                table: "Posts",
                keyColumn: "Id",
                keyValue: 15,
                column: "CreatedAt",
                value: new DateTime(2025, 11, 16, 18, 48, 59, 580, DateTimeKind.Utc).AddTicks(3881));

            migrationBuilder.UpdateData(
                table: "Posts",
                keyColumn: "Id",
                keyValue: 16,
                column: "CreatedAt",
                value: new DateTime(2025, 11, 23, 18, 48, 59, 580, DateTimeKind.Utc).AddTicks(3881));

            migrationBuilder.UpdateData(
                table: "Posts",
                keyColumn: "Id",
                keyValue: 17,
                column: "CreatedAt",
                value: new DateTime(2025, 11, 7, 18, 48, 59, 580, DateTimeKind.Utc).AddTicks(3881));

            migrationBuilder.UpdateData(
                table: "Posts",
                keyColumn: "Id",
                keyValue: 18,
                column: "CreatedAt",
                value: new DateTime(2025, 12, 6, 18, 48, 59, 580, DateTimeKind.Utc).AddTicks(3881));

            migrationBuilder.UpdateData(
                table: "Posts",
                keyColumn: "Id",
                keyValue: 19,
                column: "CreatedAt",
                value: new DateTime(2025, 10, 21, 18, 48, 59, 580, DateTimeKind.Utc).AddTicks(3881));

            migrationBuilder.UpdateData(
                table: "Posts",
                keyColumn: "Id",
                keyValue: 20,
                column: "CreatedAt",
                value: new DateTime(2025, 11, 4, 18, 48, 59, 580, DateTimeKind.Utc).AddTicks(3881));

            migrationBuilder.UpdateData(
                table: "StudentLanguages",
                keyColumn: "Id",
                keyValue: 1,
                column: "DateAdded",
                value: new DateTime(2025, 11, 8, 18, 48, 59, 580, DateTimeKind.Utc).AddTicks(3881));

            migrationBuilder.UpdateData(
                table: "StudentLanguages",
                keyColumn: "Id",
                keyValue: 2,
                column: "DateAdded",
                value: new DateTime(2025, 11, 23, 18, 48, 59, 580, DateTimeKind.Utc).AddTicks(3881));

            migrationBuilder.UpdateData(
                table: "StudentLanguages",
                keyColumn: "Id",
                keyValue: 3,
                column: "DateAdded",
                value: new DateTime(2025, 10, 9, 18, 48, 59, 580, DateTimeKind.Utc).AddTicks(3881));

            migrationBuilder.UpdateData(
                table: "StudentLanguages",
                keyColumn: "Id",
                keyValue: 4,
                column: "DateAdded",
                value: new DateTime(2025, 11, 18, 18, 48, 59, 580, DateTimeKind.Utc).AddTicks(3881));

            migrationBuilder.UpdateData(
                table: "StudentLanguages",
                keyColumn: "Id",
                keyValue: 5,
                column: "DateAdded",
                value: new DateTime(2025, 9, 9, 18, 48, 59, 580, DateTimeKind.Utc).AddTicks(3881));

            migrationBuilder.UpdateData(
                table: "StudentLanguages",
                keyColumn: "Id",
                keyValue: 6,
                column: "DateAdded",
                value: new DateTime(2025, 10, 24, 18, 48, 59, 580, DateTimeKind.Utc).AddTicks(3881));

            migrationBuilder.UpdateData(
                table: "StudentLanguages",
                keyColumn: "Id",
                keyValue: 7,
                column: "DateAdded",
                value: new DateTime(2025, 11, 13, 18, 48, 59, 580, DateTimeKind.Utc).AddTicks(3881));

            migrationBuilder.UpdateData(
                table: "StudentLanguages",
                keyColumn: "Id",
                keyValue: 8,
                column: "DateAdded",
                value: new DateTime(2025, 10, 19, 18, 48, 59, 580, DateTimeKind.Utc).AddTicks(3881));

            migrationBuilder.UpdateData(
                table: "StudentLanguages",
                keyColumn: "Id",
                keyValue: 9,
                column: "DateAdded",
                value: new DateTime(2025, 9, 24, 18, 48, 59, 580, DateTimeKind.Utc).AddTicks(3881));

            migrationBuilder.UpdateData(
                table: "StudentLanguages",
                keyColumn: "Id",
                keyValue: 10,
                column: "DateAdded",
                value: new DateTime(2025, 11, 28, 18, 48, 59, 580, DateTimeKind.Utc).AddTicks(3881));

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 1,
                column: "CreatedAt",
                value: new DateTime(2025, 12, 8, 18, 48, 59, 580, DateTimeKind.Utc).AddTicks(3881));

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 2,
                column: "CreatedAt",
                value: new DateTime(2025, 12, 8, 18, 48, 59, 580, DateTimeKind.Utc).AddTicks(3881));

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 3,
                column: "CreatedAt",
                value: new DateTime(2025, 12, 8, 18, 48, 59, 580, DateTimeKind.Utc).AddTicks(3881));

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 4,
                column: "CreatedAt",
                value: new DateTime(2025, 12, 8, 18, 48, 59, 580, DateTimeKind.Utc).AddTicks(3881));

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 5,
                column: "CreatedAt",
                value: new DateTime(2025, 12, 8, 18, 48, 59, 580, DateTimeKind.Utc).AddTicks(3881));

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 6,
                column: "CreatedAt",
                value: new DateTime(2025, 12, 8, 18, 48, 59, 580, DateTimeKind.Utc).AddTicks(3881));

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 7,
                column: "CreatedAt",
                value: new DateTime(2025, 12, 8, 18, 48, 59, 580, DateTimeKind.Utc).AddTicks(3881));

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 8,
                column: "CreatedAt",
                value: new DateTime(2025, 12, 8, 18, 48, 59, 580, DateTimeKind.Utc).AddTicks(3881));

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 9,
                column: "CreatedAt",
                value: new DateTime(2025, 12, 8, 18, 48, 59, 580, DateTimeKind.Utc).AddTicks(3881));

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 10,
                column: "CreatedAt",
                value: new DateTime(2025, 12, 8, 18, 48, 59, 580, DateTimeKind.Utc).AddTicks(3881));

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 11,
                column: "CreatedAt",
                value: new DateTime(2025, 12, 8, 18, 48, 59, 580, DateTimeKind.Utc).AddTicks(3881));
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            // Remove test student languages
            migrationBuilder.DeleteData(
                table: "StudentLanguages",
                keyColumn: "Id",
                keyValue: 100
            );

            migrationBuilder.DeleteData(
                table: "StudentLanguages",
                keyColumn: "Id",
                keyValue: 101
            );

            // Remove test tutor languages
            migrationBuilder.DeleteData(
                table: "TutorLanguages",
                keyColumn: "Id",
                keyValue: 100
            );

            migrationBuilder.DeleteData(
                table: "TutorLanguages",
                keyColumn: "Id",
                keyValue: 101
            );

            // Remove test users
            migrationBuilder.DeleteData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 100
            );

            migrationBuilder.DeleteData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 101
            );

            migrationBuilder.DeleteData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 102
            );

            migrationBuilder.UpdateData(
                table: "Posts",
                keyColumn: "Id",
                keyValue: 1,
                column: "CreatedAt",
                value: new DateTime(2025, 10, 24, 22, 31, 38, 116, DateTimeKind.Utc).AddTicks(3555));

            migrationBuilder.UpdateData(
                table: "Posts",
                keyColumn: "Id",
                keyValue: 2,
                column: "CreatedAt",
                value: new DateTime(2025, 11, 25, 22, 31, 38, 116, DateTimeKind.Utc).AddTicks(3555));

            migrationBuilder.UpdateData(
                table: "Posts",
                keyColumn: "Id",
                keyValue: 3,
                column: "CreatedAt",
                value: new DateTime(2025, 11, 26, 22, 31, 38, 116, DateTimeKind.Utc).AddTicks(3555));

            migrationBuilder.UpdateData(
                table: "Posts",
                keyColumn: "Id",
                keyValue: 4,
                column: "CreatedAt",
                value: new DateTime(2025, 11, 2, 22, 31, 38, 116, DateTimeKind.Utc).AddTicks(3555));

            migrationBuilder.UpdateData(
                table: "Posts",
                keyColumn: "Id",
                keyValue: 5,
                column: "CreatedAt",
                value: new DateTime(2025, 11, 23, 22, 31, 38, 116, DateTimeKind.Utc).AddTicks(3555));

            migrationBuilder.UpdateData(
                table: "Posts",
                keyColumn: "Id",
                keyValue: 6,
                column: "CreatedAt",
                value: new DateTime(2025, 11, 18, 22, 31, 38, 116, DateTimeKind.Utc).AddTicks(3555));

            migrationBuilder.UpdateData(
                table: "Posts",
                keyColumn: "Id",
                keyValue: 7,
                column: "CreatedAt",
                value: new DateTime(2025, 10, 21, 22, 31, 38, 116, DateTimeKind.Utc).AddTicks(3555));

            migrationBuilder.UpdateData(
                table: "Posts",
                keyColumn: "Id",
                keyValue: 8,
                column: "CreatedAt",
                value: new DateTime(2025, 11, 3, 22, 31, 38, 116, DateTimeKind.Utc).AddTicks(3555));

            migrationBuilder.UpdateData(
                table: "Posts",
                keyColumn: "Id",
                keyValue: 9,
                column: "CreatedAt",
                value: new DateTime(2025, 11, 23, 22, 31, 38, 116, DateTimeKind.Utc).AddTicks(3555));

            migrationBuilder.UpdateData(
                table: "Posts",
                keyColumn: "Id",
                keyValue: 10,
                column: "CreatedAt",
                value: new DateTime(2025, 10, 19, 22, 31, 38, 116, DateTimeKind.Utc).AddTicks(3555));

            migrationBuilder.UpdateData(
                table: "Posts",
                keyColumn: "Id",
                keyValue: 11,
                column: "CreatedAt",
                value: new DateTime(2025, 11, 19, 22, 31, 38, 116, DateTimeKind.Utc).AddTicks(3555));

            migrationBuilder.UpdateData(
                table: "Posts",
                keyColumn: "Id",
                keyValue: 12,
                column: "CreatedAt",
                value: new DateTime(2025, 11, 18, 22, 31, 38, 116, DateTimeKind.Utc).AddTicks(3555));

            migrationBuilder.UpdateData(
                table: "Posts",
                keyColumn: "Id",
                keyValue: 13,
                column: "CreatedAt",
                value: new DateTime(2025, 11, 3, 22, 31, 38, 116, DateTimeKind.Utc).AddTicks(3555));

            migrationBuilder.UpdateData(
                table: "Posts",
                keyColumn: "Id",
                keyValue: 14,
                column: "CreatedAt",
                value: new DateTime(2025, 11, 14, 22, 31, 38, 116, DateTimeKind.Utc).AddTicks(3555));

            migrationBuilder.UpdateData(
                table: "Posts",
                keyColumn: "Id",
                keyValue: 15,
                column: "CreatedAt",
                value: new DateTime(2025, 11, 11, 22, 31, 38, 116, DateTimeKind.Utc).AddTicks(3555));

            migrationBuilder.UpdateData(
                table: "Posts",
                keyColumn: "Id",
                keyValue: 16,
                column: "CreatedAt",
                value: new DateTime(2025, 11, 18, 22, 31, 38, 116, DateTimeKind.Utc).AddTicks(3555));

            migrationBuilder.UpdateData(
                table: "Posts",
                keyColumn: "Id",
                keyValue: 17,
                column: "CreatedAt",
                value: new DateTime(2025, 11, 2, 22, 31, 38, 116, DateTimeKind.Utc).AddTicks(3555));

            migrationBuilder.UpdateData(
                table: "Posts",
                keyColumn: "Id",
                keyValue: 18,
                column: "CreatedAt",
                value: new DateTime(2025, 12, 1, 22, 31, 38, 116, DateTimeKind.Utc).AddTicks(3555));

            migrationBuilder.UpdateData(
                table: "Posts",
                keyColumn: "Id",
                keyValue: 19,
                column: "CreatedAt",
                value: new DateTime(2025, 10, 16, 22, 31, 38, 116, DateTimeKind.Utc).AddTicks(3555));

            migrationBuilder.UpdateData(
                table: "Posts",
                keyColumn: "Id",
                keyValue: 20,
                column: "CreatedAt",
                value: new DateTime(2025, 10, 30, 22, 31, 38, 116, DateTimeKind.Utc).AddTicks(3555));

            migrationBuilder.UpdateData(
                table: "StudentLanguages",
                keyColumn: "Id",
                keyValue: 1,
                column: "DateAdded",
                value: new DateTime(2025, 11, 3, 22, 31, 38, 116, DateTimeKind.Utc).AddTicks(3555));

            migrationBuilder.UpdateData(
                table: "StudentLanguages",
                keyColumn: "Id",
                keyValue: 2,
                column: "DateAdded",
                value: new DateTime(2025, 11, 18, 22, 31, 38, 116, DateTimeKind.Utc).AddTicks(3555));

            migrationBuilder.UpdateData(
                table: "StudentLanguages",
                keyColumn: "Id",
                keyValue: 3,
                column: "DateAdded",
                value: new DateTime(2025, 10, 4, 22, 31, 38, 116, DateTimeKind.Utc).AddTicks(3555));

            migrationBuilder.UpdateData(
                table: "StudentLanguages",
                keyColumn: "Id",
                keyValue: 4,
                column: "DateAdded",
                value: new DateTime(2025, 11, 13, 22, 31, 38, 116, DateTimeKind.Utc).AddTicks(3555));

            migrationBuilder.UpdateData(
                table: "StudentLanguages",
                keyColumn: "Id",
                keyValue: 5,
                column: "DateAdded",
                value: new DateTime(2025, 9, 4, 22, 31, 38, 116, DateTimeKind.Utc).AddTicks(3555));

            migrationBuilder.UpdateData(
                table: "StudentLanguages",
                keyColumn: "Id",
                keyValue: 6,
                column: "DateAdded",
                value: new DateTime(2025, 10, 19, 22, 31, 38, 116, DateTimeKind.Utc).AddTicks(3555));

            migrationBuilder.UpdateData(
                table: "StudentLanguages",
                keyColumn: "Id",
                keyValue: 7,
                column: "DateAdded",
                value: new DateTime(2025, 11, 8, 22, 31, 38, 116, DateTimeKind.Utc).AddTicks(3555));

            migrationBuilder.UpdateData(
                table: "StudentLanguages",
                keyColumn: "Id",
                keyValue: 8,
                column: "DateAdded",
                value: new DateTime(2025, 10, 14, 22, 31, 38, 116, DateTimeKind.Utc).AddTicks(3555));

            migrationBuilder.UpdateData(
                table: "StudentLanguages",
                keyColumn: "Id",
                keyValue: 9,
                column: "DateAdded",
                value: new DateTime(2025, 9, 19, 22, 31, 38, 116, DateTimeKind.Utc).AddTicks(3555));

            migrationBuilder.UpdateData(
                table: "StudentLanguages",
                keyColumn: "Id",
                keyValue: 10,
                column: "DateAdded",
                value: new DateTime(2025, 11, 23, 22, 31, 38, 116, DateTimeKind.Utc).AddTicks(3555));

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 1,
                column: "CreatedAt",
                value: new DateTime(2025, 12, 3, 22, 31, 38, 116, DateTimeKind.Utc).AddTicks(3555));

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 2,
                column: "CreatedAt",
                value: new DateTime(2025, 12, 3, 22, 31, 38, 116, DateTimeKind.Utc).AddTicks(3555));

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 3,
                column: "CreatedAt",
                value: new DateTime(2025, 12, 3, 22, 31, 38, 116, DateTimeKind.Utc).AddTicks(3555));

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 4,
                column: "CreatedAt",
                value: new DateTime(2025, 12, 3, 22, 31, 38, 116, DateTimeKind.Utc).AddTicks(3555));

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 5,
                column: "CreatedAt",
                value: new DateTime(2025, 12, 3, 22, 31, 38, 116, DateTimeKind.Utc).AddTicks(3555));

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 6,
                column: "CreatedAt",
                value: new DateTime(2025, 12, 3, 22, 31, 38, 116, DateTimeKind.Utc).AddTicks(3555));

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 7,
                column: "CreatedAt",
                value: new DateTime(2025, 12, 3, 22, 31, 38, 116, DateTimeKind.Utc).AddTicks(3555));

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 8,
                column: "CreatedAt",
                value: new DateTime(2025, 12, 3, 22, 31, 38, 116, DateTimeKind.Utc).AddTicks(3555));

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 9,
                column: "CreatedAt",
                value: new DateTime(2025, 12, 3, 22, 31, 38, 116, DateTimeKind.Utc).AddTicks(3555));

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 10,
                column: "CreatedAt",
                value: new DateTime(2025, 12, 3, 22, 31, 38, 116, DateTimeKind.Utc).AddTicks(3555));

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 11,
                column: "CreatedAt",
                value: new DateTime(2025, 12, 3, 22, 31, 38, 116, DateTimeKind.Utc).AddTicks(3555));
        }
    }
}
