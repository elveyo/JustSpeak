import 'package:http/http.dart' as http;
import 'package:justspeak_desktop/models/language.dart';
import 'package:justspeak_desktop/providers/base_provider.dart';

class LanguageProvider extends BaseProvider<Language> {
  LanguageProvider() : super("Language");

  @override
  Language fromJson(dynamic json) {
    return Language.fromJson(json);
  }
}
