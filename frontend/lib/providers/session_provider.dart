import 'dart:convert';

import 'package:frontend/models/booked_session.dart';
import 'package:frontend/models/post.dart';
import 'package:frontend/models/search_result.dart';
import 'package:frontend/models/session.dart';
import 'package:frontend/models/tag.dart';
import 'package:frontend/providers/base_provider.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:http/http.dart' as http;

class SessionProvider extends BaseProvider<Session> {
  SessionProvider() : super("Session");

  @override
  Session fromJson(dynamic json) {
    return Session.fromJson(json);
  }

  Future<List<BookedSession>> getTutorSessions() async {
    Uri uri = buildUri("/tutor");

    var headers = createHeaders();
    final response = await http.get(uri, headers: headers);

    if (!isValidResponse(response)) {
      throw Exception("Failed to fetch tutor sessions");
    }

    final List<dynamic> jsonList = jsonDecode(response.body);
    final List<BookedSession> data =
        jsonList.map((item) => BookedSession.fromJson(item)).toList();

    return data;
  }

  Future<List<BookedSession>> getStudentSessions() async {
    Uri uri = buildUri("/student");
    var headers = createHeaders();
    final response = await http.get(uri, headers: headers);

    if (!isValidResponse(response)) {
      throw Exception("Failed to fetch student sessions");
    }

    final List<dynamic> jsonList = jsonDecode(response.body);
    final List<BookedSession> data =
        jsonList.map((item) => BookedSession.fromJson(item)).toList();
    return data;
  }

  Future<void> bookSession(dynamic request) async {
    Uri uri = buildUri("/book-session");
    var headers = createHeaders();
    var jsonRequest = jsonEncode(request);
    print(jsonRequest);
    var response = await http.post(uri, headers: headers, body: jsonRequest);
    print(response.body);
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      print(data);
    } else {
      throw new Exception("Unknown error");
    }
  }

  Future<String> getToken(String channelName) async {
    final userId = AuthService().user!.id;
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

  Future<SearchResult<Tag>> getTags() async {
    Uri uri = buildUri("/Tags");
    var headers = createHeaders();
    final response = await http.get(uri, headers: headers);
    if (!isValidResponse(response)) {
      throw Exception("Failed to fetch tags");
    }
    final dynamic tagJson = jsonDecode(response.body);
    // Map the paginated response to SearchResult<Tag>
    final result = SearchResult<Tag>();
    result.totalCount = tagJson['totalCount'];
    result.items =
        (tagJson['items'] as List).map((item) => Tag.fromJson(item)).toList();
    return result;
  }
}
