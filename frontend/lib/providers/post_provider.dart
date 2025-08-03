import 'package:frontend/models/post.dart';
import 'package:frontend/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class PostProvider extends BaseProvider<Post> {
  PostProvider() : super("Post");

  @override
  Post fromJson(dynamic json) {
    return Post.fromJson(json);
  }

  Future<void> likePost(int postId) async {
    final uri = buildUri("/$postId/like");
    final headers = createHeaders();
    final response = await http.post(uri, headers: headers);
    if (!isValidResponse(response)) {
      throw Exception("Unknown error");
    }
  }
}
