enum UserRole {
  tutor,
  student;

  /// Returns the display name of the role (e.g., "Tutor", "Student")
  String get displayName {
    switch (this) {
      case UserRole.tutor:
        return 'Tutor';
      case UserRole.student:
        return 'Student';
    }
  }

  /// Returns the lowercase string value (e.g., "tutor", "student")
  String get value {
    switch (this) {
      case UserRole.tutor:
        return 'Tutor';
      case UserRole.student:
        return 'Student';
    }
  }
}
