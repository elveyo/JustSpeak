import 'package:frontend/models/languale_level.dart';
import 'package:frontend/models/post.dart';
import 'package:frontend/models/session.dart';
import 'package:frontend/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class LanguageLevelProvider extends BaseProvider<LanguageLevel> {
  LanguageLevelProvider() : super("LanguageLevel");

  @override
  LanguageLevel fromJson(dynamic json) {
    return LanguageLevel.fromJson(json);
  }
}
