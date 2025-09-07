import 'package:frontend/models/level.dart';
import 'package:frontend/providers/base_provider.dart';

class LanguageLevelProvider extends BaseProvider<Level> {
  LanguageLevelProvider() : super("Level");

  @override
  Level fromJson(dynamic json) {
    return Level.fromJson(json);
  }
}
