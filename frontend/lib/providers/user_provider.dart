import 'dart:convert';

import 'package:frontend/models/level.dart';
import 'package:frontend/models/post.dart';
import 'package:frontend/models/session.dart';
import 'package:frontend/models/student.dart';
import 'package:frontend/models/tutor.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/providers/base_provider.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:http/http.dart' as http;

class UserProvider extends BaseProvider<User> {
  UserProvider() : super("User");

  @override
  User fromJson(dynamic json) {
    return User.fromJson(json);
  }

  Future<String> register(dynamic request) async {
    final uri = buildUri("/register");
    final headers = createHeaders();
    final body = jsonEncode(request);

    final response = await http.post(uri, headers: headers, body: body);

    if (!isValidResponse(response)) {
      throw Exception("Registration failed: ${response.body}");
    }
    print(response.body);

    final data = jsonDecode(response.body);
    return data["token"];
  }

  Future<Tutor> getTutorData(int tutorId) async {
    final uri = buildUri("/tutor-profile/$tutorId");
    final headers = createHeaders();
    final response = await http.get(uri, headers: headers);

    print(uri);
    if (!isValidResponse(response)) {
      throw Exception("Unknown error");
    }
    var data = jsonDecode(response.body);
    return Tutor.fromJson(data);
  }

  Future<Student> getStudentData(int studentId) async {
    final uri = buildUri("/student-profile/$studentId");
    final headers = createHeaders();
    final response = await http.get(uri, headers: headers);

    print(uri);
    if (!isValidResponse(response)) {
      throw Exception("Unknown error");
    }
    var data = jsonDecode(response.body);
    return Student.fromJson(data);
  }
}
