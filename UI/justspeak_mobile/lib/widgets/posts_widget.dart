import 'package:flutter/material.dart';
import 'package:frontend/models/post.dart';
import 'package:frontend/models/search_result.dart';
import 'package:frontend/providers/post_provider.dart';
import 'package:frontend/widgets/post_card.dart';
import 'package:provider/provider.dart';

class PostsListWidget extends StatefulWidget {
  final int? userId; // null = global feed (JWT sa backend-a)

  const PostsListWidget({super.key, this.userId});

  @override
  State<PostsListWidget> createState() => _PostsListWidgetState();
}

class _PostsListWidgetState extends State<PostsListWidget> {
  SearchResult<Post>? posts;
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 0;
  final int _pageSize = 10;
  bool _isLoading = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPosts(initial: true);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoading &&
        _hasMore) {
      _loadPosts();
    }
  }

  Future<void> _loadPosts({bool initial = false}) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    final postProvider = Provider.of<PostProvider>(context, listen: false);

    try {
      final pageToFetch = initial ? 0 : _currentPage;
      final filter = {"page": pageToFetch, "pageSize": _pageSize};

      if (widget.userId != null) {
        filter["userId"] = widget.userId!;
      }

      final items = await postProvider.get(filter: filter);

      if (!mounted) return;

      setState(() {
        if (initial || posts == null) {
          posts = items;
        } else {
          posts!.items!.addAll(items.items ?? []);
        }
        _currentPage++;
        _hasMore = (posts!.items!.length < (posts!.totalCount ?? 0));
      });
    } catch (e) {
      if (mounted) posts = null;
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _refreshPosts() async {
    setState(() {
      _currentPage = 0;
      _hasMore = true;
      posts = null;
    });
    await _loadPosts(initial: true);
  }

  Future<void> _likePost(int postId) async {
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    await postProvider.likePost(postId);
  }

  @override
  Widget build(BuildContext context) {
    if (posts == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (posts!.items == null || posts!.items!.isEmpty) {
      return const Center(child: Text("No posts yet."));
    }

    return RefreshIndicator(
      onRefresh: _refreshPosts,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: posts!.items!.length + (_hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < posts!.items!.length) {
            final item = posts!.items![index];
            return FeedCard(
              item: item,
              onLike: (postId) => _likePost(postId),
              onRefresh: _refreshPosts,
            );
          } else {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
    );
  }
}
