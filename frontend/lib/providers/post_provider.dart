import 'dart:convert';

import 'package:frontend/models/comment.dart';
import 'package:frontend/models/post.dart';
import 'package:frontend/models/search_result.dart';
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

  Future<void> postComment(int postId, String content) async {
    final uri = buildUri("/$postId/comments");
    final headers = createHeaders();
    final request = {"content": content};
    final body = jsonEncode(request);

    final response = await http.post(uri, headers: headers, body: body);
    print(response.body);

    if (!isValidResponse(response)) {
      throw Exception("Failed to post comment");
    }
  }

  Future<SearchResult<Comment>> getComments(int postId) async {
    final uri = buildUri("/$postId/comments");
    final headers = createHeaders();
    final response = await http.get(uri, headers: headers);
    if (!isValidResponse(response)) {
      throw Exception("Failed to fetch comments");
    }

    final data = jsonDecode(response.body);

    var result = SearchResult<Comment>();

    result.totalCount = data['totalCount'];
    result.items = List<Comment>.from(
      data["items"].map((e) => Comment.fromJson(e)),
    );

    return result;
  }
}
