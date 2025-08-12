import 'package:flutter/material.dart';
import 'package:frontend/layouts/master_screen.dart';
import 'package:frontend/models/post.dart';
import 'package:frontend/models/search_result.dart';
import 'package:frontend/providers/post_provider.dart';
import 'package:frontend/screens/add_post_screen.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

import 'package:timeago/timeago.dart' as timeago;

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  SearchResult<Post>? posts;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadPosts());
    print(posts);
  }

  Future<void> _loadPosts() async {
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    try {
      final items = await postProvider.get();
      posts = items;
    } catch (e) {
      posts = null; // Optionally show a snackbar or error UI
    }
    setState(() {
      posts = posts;
    });
  }

  Future<void> _likePost(int postId) async {
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    await postProvider.likePost(postId);
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      title: 'Home',
      child:
          posts == null
              ? const Center(child: CircularProgressIndicator())
              : Stack(
                children: [
                  Container(
                    color: Colors.grey[50],
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await Future.delayed(const Duration(seconds: 1));
                        setState(() {
                          // Osvježi feed
                        });
                      },
                      child: ListView.builder(
                        itemCount: posts!.totalCount,
                        itemBuilder: (context, index) {
                          final item = posts!.items![index];
                          return _buildFeedCard(item);
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Video call button
                        FloatingActionButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/calls');
                          },
                          backgroundColor: Colors.green,
                          mini: true,
                          child: const Icon(
                            Icons.video_call,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Add post button
                        FloatingActionButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreatePostScreen(),
                              ),
                            );
                          },
                          backgroundColor: Colors.purple,
                          child: const Icon(Icons.add, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
    );
  }

  Widget _buildFeedCard(Post item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User header
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                    'https://via.placeholder.com/50',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            item.authorName ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          if (item.userRole == 'Tutor') ...[
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.verified,
                              size: 18,
                              color: Color.fromARGB(255, 53, 220, 100),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                Text(
                  timeago.format(DateTime.parse(item.createdAt)),
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Image container (base64 support)
            if (item.imageUrl.isNotEmpty)
              Container(
                width: double.infinity,
                height: 180,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _buildImageFromBase64OrNull(item.imageUrl),
              ),
            // Content
            Text(
              item.content,
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
            const SizedBox(height: 16),
            // Action buttons
            Row(
              children: [
                _buildActionButton(
                  icon:
                      item.likedByCurrUser
                          ? Icons.favorite
                          : Icons.favorite_border,
                  label: '${item.numOfLikes}',
                  onTap: () {
                    setState(() {
                      if (item.likedByCurrUser) {
                        item.likedByCurrUser = false;
                        item.numOfLikes--;
                      } else {
                        item.likedByCurrUser = true;
                        item.numOfLikes++;
                      }

                      _likePost(item.id);
                    });
                  },
                ),
                const SizedBox(width: 24),
                _buildActionButton(
                  icon: Icons.chat_bubble_outline,
                  label: '${item.numOfComments}',
                  onTap: () {
                    // Show comments
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageFromBase64OrNull(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return const Center(
        child: Icon(Icons.image, color: Colors.grey, size: 48),
      );
    }

    // Check if it's a base64 string (not a URL)
    final isBase64 = !imageUrl.startsWith('http');
    if (isBase64) {
      try {
        // Remove data:image/...;base64, if present
        final base64RegExp = RegExp(r'data:image/[^;]+;base64,');
        String pureBase64 = imageUrl.replaceAll(base64RegExp, '');
        final bytes = base64Decode(pureBase64);
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.memory(
            bytes,
            width: double.infinity,
            height: 180,
            fit: BoxFit.cover,
            errorBuilder:
                (context, error, stackTrace) => const Center(
                  child: Icon(Icons.broken_image, color: Colors.grey, size: 48),
                ),
          ),
        );
      } catch (e) {
        return const Center(
          child: Icon(Icons.broken_image, color: Colors.grey, size: 48),
        );
      }
    } else {
      // Fallback to network image
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          imageUrl,
          width: double.infinity,
          height: 180,
          fit: BoxFit.cover,
          errorBuilder:
              (context, error, stackTrace) => const Center(
                child: Icon(Icons.broken_image, color: Colors.grey, size: 48),
              ),
        ),
      );
    }
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
        ],
      ),
    );
  }
}
