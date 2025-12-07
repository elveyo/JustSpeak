import 'dart:convert';

import 'package:frontend/models/post.dart';
import 'package:frontend/models/tutor_schedule.dart';
import 'package:frontend/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class ScheduleProvider extends BaseProvider<Schedule> {
  ScheduleProvider() : super("Schedule");

  @override
  Schedule fromJson(dynamic json) {
    return Schedule.fromJson(json);
  }

  Future<Schedule?> getSchedule(int userId) async {
    Uri uri = buildUri("/tutor?userId=$userId");

    print(uri);
    final headers = createHeaders();
    final response = await http.get(uri, headers: headers);
    print(response.body);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return Schedule.fromJson(data);
    } else {
      throw Exception('Failed to load schedule');
    }
  }

  Future<Schedule> updateSchedule(int scheduleId, dynamic request) async {
    Uri uri = buildUri("/$scheduleId");
    final headers = createHeaders();
    final body = jsonEncode(request);
    
    final response = await http.put(uri, headers: headers, body: body);
    
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return Schedule.fromJson(data);
    } else {
      final errorBody = response.body;
      throw Exception('Failed to update schedule: $errorBody');
    }
  }
}
