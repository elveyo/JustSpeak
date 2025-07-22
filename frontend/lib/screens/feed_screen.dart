import 'package:flutter/material.dart';
import 'package:frontend/layouts/master_screen.dart';
import 'package:frontend/models/post.dart';
import 'package:frontend/models/search_result.dart';
import 'package:frontend/providers/post_provider.dart';
import 'package:provider/provider.dart';

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
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    final items = await postProvider.get();
    setState(() {
      posts = items;
    });
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
                        padding: const EdgeInsets.all(16),
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
                    child: FloatingActionButton(
                      onPressed: _showAddPostDialog,
                      backgroundColor: Colors.purple,
                      child: const Icon(Icons.add, color: Colors.white),
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
                      Text(
                        item.authorName!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  'Tutor' == 'Tutor'
                                      ? Colors.purple.withOpacity(0.1)
                                      : Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Tutor',
                              style: TextStyle(
                                fontSize: 12,
                                color:
                                    'Tutor' == 'Tutor'
                                        ? Colors.purple
                                        : Colors.blue,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'English',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.green,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Text(
                  '2 minute ago',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 12),
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
                  icon: Icons.favorite_border,
                  label: '${20}',
                  onTap: () {
                    setState(() {});
                  },
                ),
                const SizedBox(width: 24),
                _buildActionButton(
                  icon: Icons.chat_bubble_outline,
                  label: '${20}',
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

  void _showAddPostDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Create Post'),
            content: const TextField(
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'What\'s on your mind?',
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Add post logic here
                  Navigator.pop(context);
                },
                child: const Text('Post'),
              ),
            ],
          ),
    );
  }
}
