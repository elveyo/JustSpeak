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
}
