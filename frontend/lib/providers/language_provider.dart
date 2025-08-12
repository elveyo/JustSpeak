import 'package:frontend/models/language.dart';
import 'package:frontend/models/post.dart';
import 'package:frontend/models/session.dart';
import 'package:frontend/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class LanguageProvider extends BaseProvider<Language> {
  LanguageProvider() : super("Language");

  @override
  Language fromJson(dynamic json) {
    return Language.fromJson(json);
  }
}
