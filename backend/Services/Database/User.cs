using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Models.Enums;

namespace Services.Database
{
    public class User
    {
        public int Id { get; set; }

        public string FirstName { get; set; } = string.Empty;
        public string LastName { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string ImageUrl { get; set; } = string.Empty;
        public string Bio { get; set; } = string.Empty;
        public string PasswordHash { get; set; } = string.Empty;
        public string PasswordSalt { get; set; } = string.Empty;
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public string Discriminator { get; set; } = null!;
        public UserRole Role =>
            Enum.TryParse<UserRole>(Discriminator, out var role)
                ? role
                : throw new ArgumentException(
                    $"Invalid role discriminator: {Discriminator}. Valid values are: {string.Join(", ", Enum.GetNames<UserRole>())}"
                );

        public string FullName => FirstName + " " + LastName;
    }
}
