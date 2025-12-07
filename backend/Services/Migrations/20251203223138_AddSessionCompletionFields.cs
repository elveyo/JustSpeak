using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Services.Migrations
{
    /// <inheritdoc />
    public partial class AddSessionCompletionFields : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "Notes",
                table: "StudentTutorSessions",
                newName: "Note");

            migrationBuilder.AddColumn<bool>(
                name: "IsCompleted",
                table: "StudentTutorSessions",
                type: "bit",
                nullable: false,
                defaultValue: false);

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

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "IsCompleted",
                table: "StudentTutorSessions");

            migrationBuilder.RenameColumn(
                name: "Note",
                table: "StudentTutorSessions",
                newName: "Notes");

            migrationBuilder.UpdateData(
                table: "Posts",
                keyColumn: "Id",
                keyValue: 1,
                column: "CreatedAt",
                value: new DateTime(2025, 10, 14, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259));

            migrationBuilder.UpdateData(
                table: "Posts",
                keyColumn: "Id",
                keyValue: 2,
                column: "CreatedAt",
                value: new DateTime(2025, 11, 15, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259));

            migrationBuilder.UpdateData(
                table: "Posts",
                keyColumn: "Id",
                keyValue: 3,
                column: "CreatedAt",
                value: new DateTime(2025, 11, 16, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259));

            migrationBuilder.UpdateData(
                table: "Posts",
                keyColumn: "Id",
                keyValue: 4,
                column: "CreatedAt",
                value: new DateTime(2025, 10, 23, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259));

            migrationBuilder.UpdateData(
                table: "Posts",
                keyColumn: "Id",
                keyValue: 5,
                column: "CreatedAt",
                value: new DateTime(2025, 11, 13, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259));

            migrationBuilder.UpdateData(
                table: "Posts",
                keyColumn: "Id",
                keyValue: 6,
                column: "CreatedAt",
                value: new DateTime(2025, 11, 8, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259));

            migrationBuilder.UpdateData(
                table: "Posts",
                keyColumn: "Id",
                keyValue: 7,
                column: "CreatedAt",
                value: new DateTime(2025, 10, 11, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259));

            migrationBuilder.UpdateData(
                table: "Posts",
                keyColumn: "Id",
                keyValue: 8,
                column: "CreatedAt",
                value: new DateTime(2025, 10, 24, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259));

            migrationBuilder.UpdateData(
                table: "Posts",
                keyColumn: "Id",
                keyValue: 9,
                column: "CreatedAt",
                value: new DateTime(2025, 11, 13, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259));

            migrationBuilder.UpdateData(
                table: "Posts",
                keyColumn: "Id",
                keyValue: 10,
                column: "CreatedAt",
                value: new DateTime(2025, 10, 9, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259));

            migrationBuilder.UpdateData(
                table: "Posts",
                keyColumn: "Id",
                keyValue: 11,
                column: "CreatedAt",
                value: new DateTime(2025, 11, 9, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259));

            migrationBuilder.UpdateData(
                table: "Posts",
                keyColumn: "Id",
                keyValue: 12,
                column: "CreatedAt",
                value: new DateTime(2025, 11, 8, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259));

            migrationBuilder.UpdateData(
                table: "Posts",
                keyColumn: "Id",
                keyValue: 13,
                column: "CreatedAt",
                value: new DateTime(2025, 10, 24, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259));

            migrationBuilder.UpdateData(
                table: "Posts",
                keyColumn: "Id",
                keyValue: 14,
                column: "CreatedAt",
                value: new DateTime(2025, 11, 4, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259));

            migrationBuilder.UpdateData(
                table: "Posts",
                keyColumn: "Id",
                keyValue: 15,
                column: "CreatedAt",
                value: new DateTime(2025, 11, 1, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259));

            migrationBuilder.UpdateData(
                table: "Posts",
                keyColumn: "Id",
                keyValue: 16,
                column: "CreatedAt",
                value: new DateTime(2025, 11, 8, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259));

            migrationBuilder.UpdateData(
                table: "Posts",
                keyColumn: "Id",
                keyValue: 17,
                column: "CreatedAt",
                value: new DateTime(2025, 10, 23, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259));

            migrationBuilder.UpdateData(
                table: "Posts",
                keyColumn: "Id",
                keyValue: 18,
                column: "CreatedAt",
                value: new DateTime(2025, 11, 21, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259));

            migrationBuilder.UpdateData(
                table: "Posts",
                keyColumn: "Id",
                keyValue: 19,
                column: "CreatedAt",
                value: new DateTime(2025, 10, 6, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259));

            migrationBuilder.UpdateData(
                table: "Posts",
                keyColumn: "Id",
                keyValue: 20,
                column: "CreatedAt",
                value: new DateTime(2025, 10, 20, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259));

            migrationBuilder.UpdateData(
                table: "StudentLanguages",
                keyColumn: "Id",
                keyValue: 1,
                column: "DateAdded",
                value: new DateTime(2025, 10, 24, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259));

            migrationBuilder.UpdateData(
                table: "StudentLanguages",
                keyColumn: "Id",
                keyValue: 2,
                column: "DateAdded",
                value: new DateTime(2025, 11, 8, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259));

            migrationBuilder.UpdateData(
                table: "StudentLanguages",
                keyColumn: "Id",
                keyValue: 3,
                column: "DateAdded",
                value: new DateTime(2025, 9, 24, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259));

            migrationBuilder.UpdateData(
                table: "StudentLanguages",
                keyColumn: "Id",
                keyValue: 4,
                column: "DateAdded",
                value: new DateTime(2025, 11, 3, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259));

            migrationBuilder.UpdateData(
                table: "StudentLanguages",
                keyColumn: "Id",
                keyValue: 5,
                column: "DateAdded",
                value: new DateTime(2025, 8, 25, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259));

            migrationBuilder.UpdateData(
                table: "StudentLanguages",
                keyColumn: "Id",
                keyValue: 6,
                column: "DateAdded",
                value: new DateTime(2025, 10, 9, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259));

            migrationBuilder.UpdateData(
                table: "StudentLanguages",
                keyColumn: "Id",
                keyValue: 7,
                column: "DateAdded",
                value: new DateTime(2025, 10, 29, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259));

            migrationBuilder.UpdateData(
                table: "StudentLanguages",
                keyColumn: "Id",
                keyValue: 8,
                column: "DateAdded",
                value: new DateTime(2025, 10, 4, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259));

            migrationBuilder.UpdateData(
                table: "StudentLanguages",
                keyColumn: "Id",
                keyValue: 9,
                column: "DateAdded",
                value: new DateTime(2025, 9, 9, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259));

            migrationBuilder.UpdateData(
                table: "StudentLanguages",
                keyColumn: "Id",
                keyValue: 10,
                column: "DateAdded",
                value: new DateTime(2025, 11, 13, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259));

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 1,
                column: "CreatedAt",
                value: new DateTime(2025, 11, 23, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259));

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 2,
                column: "CreatedAt",
                value: new DateTime(2025, 11, 23, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259));

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 3,
                column: "CreatedAt",
                value: new DateTime(2025, 11, 23, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259));

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 4,
                column: "CreatedAt",
                value: new DateTime(2025, 11, 23, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259));

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 5,
                column: "CreatedAt",
                value: new DateTime(2025, 11, 23, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259));

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 6,
                column: "CreatedAt",
                value: new DateTime(2025, 11, 23, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259));

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 7,
                column: "CreatedAt",
                value: new DateTime(2025, 11, 23, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259));

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 8,
                column: "CreatedAt",
                value: new DateTime(2025, 11, 23, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259));

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 9,
                column: "CreatedAt",
                value: new DateTime(2025, 11, 23, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259));

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 10,
                column: "CreatedAt",
                value: new DateTime(2025, 11, 23, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259));

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 11,
                column: "CreatedAt",
                value: new DateTime(2025, 11, 23, 16, 2, 56, 646, DateTimeKind.Utc).AddTicks(9259));
        }
    }
}
