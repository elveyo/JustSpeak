import 'dart:convert';

import 'package:frontend/models/post.dart';
import 'package:frontend/models/session.dart';
import 'package:frontend/providers/base_provider.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:http/http.dart' as http;

class SessionProvider extends BaseProvider<Session> {
  SessionProvider() : super("Session");

  @override
  Session fromJson(dynamic json) {
    return Session.fromJson(json);
  }

  Future<String> getToken(String channelName) async {
    final userId = AuthService().userId;
    Uri uri = buildUri("/generate-token");
    print(uri);
    var headers = createHeaders();
    var request = {"channelName": channelName, "userId": userId};
    var jsonRequest = jsonEncode(request);
    print(jsonRequest);
    final response = await http.post(uri, headers: headers, body: jsonRequest);
    print(response.body);
    if (!isValidResponse(response)) {
      throw Exception("Unknown error");
    }
    print(response.body);
    return response.body;
  }
}
