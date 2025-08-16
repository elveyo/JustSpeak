using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Services.Migrations
{
    /// <inheritdoc />
    public partial class UpdateSession : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "NumberOfUsers",
                table: "Sessions",
                newName: "NumOfUsers");

            migrationBuilder.AddColumn<string>(
                name: "ChannelName",
                table: "Sessions",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");

        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "ChannelName",
                table: "Sessions");

            migrationBuilder.RenameColumn(
                name: "NumOfUsers",
                table: "Sessions",
                newName: "NumberOfUsers");

        }
    }
}
