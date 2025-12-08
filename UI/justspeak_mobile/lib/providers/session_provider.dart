import 'dart:convert';

import 'package:frontend/models/booked_session.dart';
import 'package:frontend/models/post.dart';
import 'package:frontend/models/search_result.dart';
import 'package:frontend/models/session.dart';
import 'package:frontend/models/tag.dart';
import 'package:frontend/providers/base_provider.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/providers/payment_provider.dart';
import 'package:http/http.dart' as http;
import 'package:table_calendar/table_calendar.dart';

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

    print(data);
    return data;
  }

  Future<int> bookSession(dynamic request) async {
    Uri uri = buildUri("/book-session");
    var headers = createHeaders();
    var jsonRequest = jsonEncode(request);
    var response = await http.post(uri, headers: headers, body: jsonRequest);
    if (isValidResponse(response)) {
      return int.parse(response.body);
    } else {
      throw Exception("Problem happened while booking session!");
    }
  }

  Future<String> getToken(String channelName) async {
    final user = AuthService().user;
    if (user == null) {
      throw Exception("User not logged in");
    }
    final userId = user.id;
    Uri uri = buildUri("/generate-token");
    var headers = createHeaders();
    var request = {
      "channelName": channelName,
      "userAccount": user.fullName,
    };
    var jsonRequest = jsonEncode(request);
    final response = await http.post(uri, headers: headers, body: jsonRequest);
    if (!isValidResponse(response)) {
      throw Exception("Unknown error");
    }
    return response.body;
  }

  Future<bool> joinSession(int sessionId) async {
    Uri uri = buildUri("/$sessionId/join");
    var headers = createHeaders();
    final response = await http.post(uri, headers: headers);
    print(response);
    if (response.statusCode == 200) {
      print("Session joined successfully");
      return true;
    } else {
      return false;
    }
  }

  Future<void> leaveSession(int sessionId) async {
    Uri uri = buildUri("/$sessionId/leave");
    var headers = createHeaders();
    await http.post(uri, headers: headers);
  }

  Future<bool> startSession(int sessionId) async {
    Uri uri = buildUri("/$sessionId/start");
    var headers = createHeaders();
    final response = await http.post(uri, headers: headers);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
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


  Future<void> rateUsers(
    int sessionId,
    int languageId,
    int levelId,
    List<Map<String, dynamic>> ratings,
  ) async {
    Uri uri = buildUri("/rate-users");
    var headers = createHeaders();
    var request = {
      "sessionId": sessionId,
      "languageId": languageId,
      "levelId": levelId,
      "ratings": ratings,
    };
    var jsonRequest = jsonEncode(request);
    await http.post(uri, headers: headers, body: jsonRequest);
  }

  Future<bool> completeSession(int sessionId, String? note) async {
    Uri uri = buildUri("/$sessionId/complete");
    var headers = createHeaders();
    var request = {"note": note};
    var jsonRequest = jsonEncode(request);
    
    final response = await http.post(uri, headers: headers, body: jsonRequest);
    return response.statusCode == 200;
  }
}
