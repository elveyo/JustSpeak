import 'package:frontend/models/post.dart';
import 'package:frontend/providers/base_provider.dart';

class PostProvider extends BaseProvider<Post> {
  PostProvider() : super("Post");

  @override
  Post fromJson(dynamic json) {
    return Post.fromJson(json);
  }
}
