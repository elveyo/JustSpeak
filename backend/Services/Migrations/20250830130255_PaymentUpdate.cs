using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Services.Migrations
{
    /// <inheritdoc />
    public partial class PaymentUpdate : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Payments_Users_StudentId",
                table: "Payments");

            migrationBuilder.DropForeignKey(
                name: "FK_Payments_Users_TutorId",
                table: "Payments");

            migrationBuilder.DropIndex(
                name: "IX_Payments_StudentId",
                table: "Payments");

            migrationBuilder.DropIndex(
                name: "IX_Payments_TutorId",
                table: "Payments");

            migrationBuilder.DropColumn(
                name: "StudentId",
                table: "Payments");

            migrationBuilder.DropColumn(
                name: "TutorId",
                table: "Payments");

            migrationBuilder.RenameColumn(
                name: "PaymentStatus",
                table: "Payments",
                newName: "StripeTransactionId");

            migrationBuilder.AddColumn<string>(
                name: "Status",
                table: "Payments",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 1,
                column: "CreatedAt",
                value: new DateTime(2025, 8, 30, 13, 2, 55, 261, DateTimeKind.Utc).AddTicks(4002));

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 2,
                column: "CreatedAt",
                value: new DateTime(2025, 8, 30, 13, 2, 55, 261, DateTimeKind.Utc).AddTicks(4031));

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 3,
                column: "CreatedAt",
                value: new DateTime(2025, 8, 30, 13, 2, 55, 261, DateTimeKind.Utc).AddTicks(4033));

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 4,
                column: "CreatedAt",
                value: new DateTime(2025, 8, 30, 13, 2, 55, 261, DateTimeKind.Utc).AddTicks(4057));

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 5,
                column: "CreatedAt",
                value: new DateTime(2025, 8, 30, 13, 2, 55, 261, DateTimeKind.Utc).AddTicks(4060));
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Status",
                table: "Payments");

            migrationBuilder.RenameColumn(
                name: "StripeTransactionId",
                table: "Payments",
                newName: "PaymentStatus");

            migrationBuilder.AddColumn<int>(
                name: "StudentId",
                table: "Payments",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "TutorId",
                table: "Payments",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 1,
                column: "CreatedAt",
                value: new DateTime(2025, 8, 28, 16, 42, 17, 853, DateTimeKind.Utc).AddTicks(2128));

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 2,
                column: "CreatedAt",
                value: new DateTime(2025, 8, 28, 16, 42, 17, 853, DateTimeKind.Utc).AddTicks(2161));

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 3,
                column: "CreatedAt",
                value: new DateTime(2025, 8, 28, 16, 42, 17, 853, DateTimeKind.Utc).AddTicks(2164));

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 4,
                column: "CreatedAt",
                value: new DateTime(2025, 8, 28, 16, 42, 17, 853, DateTimeKind.Utc).AddTicks(2190));

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 5,
                column: "CreatedAt",
                value: new DateTime(2025, 8, 28, 16, 42, 17, 853, DateTimeKind.Utc).AddTicks(2193));

            migrationBuilder.CreateIndex(
                name: "IX_Payments_StudentId",
                table: "Payments",
                column: "StudentId");

            migrationBuilder.CreateIndex(
                name: "IX_Payments_TutorId",
                table: "Payments",
                column: "TutorId");

            migrationBuilder.AddForeignKey(
                name: "FK_Payments_Users_StudentId",
                table: "Payments",
                column: "StudentId",
                principalTable: "Users",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_Payments_Users_TutorId",
                table: "Payments",
                column: "TutorId",
                principalTable: "Users",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
