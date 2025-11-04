class StatisticsResponse {
  final int studentsNum;
  final int tutorsNum;
  final int sessionsNum;
  final List<Map<int, int>> users;
  final List<Map<int, int>> sessions;

  StatisticsResponse({
    required this.studentsNum,
    required this.tutorsNum,
    required this.sessionsNum,
    required this.users,
    required this.sessions,
  });

  factory StatisticsResponse.fromJson(Map<String, dynamic> json) {
    return StatisticsResponse(
      studentsNum: json['studentsNum'] ?? json['StudentsNum'] ?? 0,
      tutorsNum: json['tutorsNum'] ?? json['TutorsNum'] ?? 0,
      sessionsNum: json['sessionsNum'] ?? json['SessionsNum'] ?? 0,
      users: (json['users'] ?? json['Users'] ?? [])
          .map<Map<int, int>>(
            (item) => Map<int, int>.from(
              (item as Map).map(
                (k, v) => MapEntry(int.parse(k.toString()), v as int),
              ),
            ),
          )
          .toList(),
      sessions: (json['sessions'] ?? json['Sessions'] ?? [])
          .map<Map<int, int>>(
            (item) => Map<int, int>.from(
              (item as Map).map(
                (k, v) => MapEntry(int.parse(k.toString()), v as int),
              ),
            ),
          )
          .toList(),
    );
  }
}
