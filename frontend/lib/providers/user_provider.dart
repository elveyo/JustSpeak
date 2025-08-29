import 'package:frontend/models/languale_level.dart';
import 'package:frontend/models/post.dart';
import 'package:frontend/models/session.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class UserProvider extends BaseProvider<User> {
  UserProvider() : super("LanguageLevel");

  @override
  User fromJson(dynamic json) {
    return User.fromJson(json);
  }
}
