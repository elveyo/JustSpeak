import 'package:justspeak_desktop/models/level.dart';
import 'package:justspeak_desktop/providers/base_provider.dart';

class LevelProvider extends BaseProvider<Level> {
  LevelProvider() : super("Level");

  @override
  Level fromJson(dynamic json) {
    return Level.fromJson(json);
  }
}
