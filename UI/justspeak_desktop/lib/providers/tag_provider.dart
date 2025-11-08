import 'package:justspeak_desktop/models/tag.dart';
import 'package:justspeak_desktop/providers/base_provider.dart';

class TagProvider extends BaseProvider<Tag> {
  TagProvider() : super("Tag");

  @override
  Tag fromJson(dynamic json) {
    return Tag.fromJson(json);
  }
}
