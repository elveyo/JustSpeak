import 'dart:convert';

import 'package:frontend/models/level.dart';
import 'package:frontend/models/post.dart';
import 'package:frontend/models/session.dart';
import 'package:frontend/models/tutor.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class UserProvider extends BaseProvider<User> {
  UserProvider() : super("User");

  @override
  User fromJson(dynamic json) {
    return User.fromJson(json);
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
}
