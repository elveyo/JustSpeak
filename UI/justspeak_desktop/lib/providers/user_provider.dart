import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:justspeak_desktop/models/search_result.dart';
import 'package:justspeak_desktop/models/statistics.dart';
import 'package:justspeak_desktop/models/user.dart';
import 'package:justspeak_desktop/providers/base_provider.dart';

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

  Future<String> login(dynamic request) async {
    final uri = buildUri("/login");
    final headers = createHeaders();
    final body = jsonEncode(request);
    print(uri);

    final response = await http.post(uri, headers: headers, body: body);
    if (!isValidResponse(response)) {
      throw Exception("Login failed: ${response.body}");
    }

    final data = jsonDecode(response.body);
    return data["token"];
  }

  Future<StatisticsResponse> getStatistics() async {
    final uri = buildUri("/statistics");
    final headers = createHeaders();

    final response = await http.get(uri, headers: headers);
    if (!isValidResponse(response)) {
      throw Exception("Statistics failed: ${response.body}");
    }

    StatisticsResponse data = StatisticsResponse.fromJson(
      jsonDecode(response.body),
    );
    return data;
  }
}
