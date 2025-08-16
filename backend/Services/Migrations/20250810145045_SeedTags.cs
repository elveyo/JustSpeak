using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace Services.Migrations
{
    /// <inheritdoc />
    public partial class SeedTags : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.InsertData(
                table: "Tags",
                columns: new[] { "Id", "Color", "Name", "SessionId" },
                values: new object[,]
                {
                    { 1, "#4CAF50", "Conversation", null },
                    { 2, "#2196F3", "Grammar", null },
                    { 3, "#FF9800", "Pronunciation", null },
                    { 4, "#9C27B0", "Travel", null },
                    { 5, "#FF5722", "Food & Cooking", null },
                    { 6, "#607D8B", "Business", null },
                    { 7, "#E91E63", "Culture", null },
                    { 8, "#795548", "Daily Life", null },
                    { 9, "#00BCD4", "Hobbies", null },
                    { 10, "#8BC34A", "Health & Wellness", null }
                });

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 1,
                column: "CreatedAt",
                value: new DateTime(2025, 8, 10, 14, 50, 45, 187, DateTimeKind.Utc).AddTicks(3057));

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 2,
                column: "CreatedAt",
                value: new DateTime(2025, 8, 10, 14, 50, 45, 187, DateTimeKind.Utc).AddTicks(3100));

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 3,
                column: "CreatedAt",
                value: new DateTime(2025, 8, 10, 14, 50, 45, 187, DateTimeKind.Utc).AddTicks(3104));

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 4,
                column: "CreatedAt",
                value: new DateTime(2025, 8, 10, 14, 50, 45, 187, DateTimeKind.Utc).AddTicks(3138));

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 5,
                column: "CreatedAt",
                value: new DateTime(2025, 8, 10, 14, 50, 45, 187, DateTimeKind.Utc).AddTicks(3142));
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "Tags",
                keyColumn: "Id",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Tags",
                keyColumn: "Id",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Tags",
                keyColumn: "Id",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "Tags",
                keyColumn: "Id",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "Tags",
                keyColumn: "Id",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "Tags",
                keyColumn: "Id",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "Tags",
                keyColumn: "Id",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "Tags",
                keyColumn: "Id",
                keyValue: 8);

            migrationBuilder.DeleteData(
                table: "Tags",
                keyColumn: "Id",
                keyValue: 9);

            migrationBuilder.DeleteData(
                table: "Tags",
                keyColumn: "Id",
                keyValue: 10);

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 1,
                column: "CreatedAt",
                value: new DateTime(2025, 8, 10, 14, 33, 45, 734, DateTimeKind.Utc).AddTicks(6475));

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 2,
                column: "CreatedAt",
                value: new DateTime(2025, 8, 10, 14, 33, 45, 734, DateTimeKind.Utc).AddTicks(6517));

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 3,
                column: "CreatedAt",
                value: new DateTime(2025, 8, 10, 14, 33, 45, 734, DateTimeKind.Utc).AddTicks(6522));

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 4,
                column: "CreatedAt",
                value: new DateTime(2025, 8, 10, 14, 33, 45, 734, DateTimeKind.Utc).AddTicks(6551));

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 5,
                column: "CreatedAt",
                value: new DateTime(2025, 8, 10, 14, 33, 45, 734, DateTimeKind.Utc).AddTicks(6555));
        }
    }
}
