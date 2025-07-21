import 'package:flutter/material.dart';
import 'package:frontend/layouts/master_screen.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final List<Map<String, dynamic>> _feedItems = [
    {
      'id': 1,
      'userName': 'Sarah Johnson',
      'userRole': 'Tutor',
      'language': 'Spanish',
      'content':
          'Just finished an amazing Spanish conversation session! 🗣️ My student made incredible progress today. Remember, practice makes perfect!',
      'likes': 12,
      'comments': 3,
      'timeAgo': '2 hours ago',
      'avatar': 'https://via.placeholder.com/50',
    },
    {
      'id': 2,
      'userName': 'Alex Chen',
      'userRole': 'Student',
      'language': 'French',
      'content':
          'Had my first French lesson today! 🇫🇷 My tutor was so patient and helpful. Can\'t wait for the next session!',
      'likes': 8,
      'comments': 5,
      'timeAgo': '4 hours ago',
      'avatar': 'https://via.placeholder.com/50',
    },
    {
      'id': 3,
      'userName': 'Maria Rodriguez',
      'userRole': 'Tutor',
      'language': 'English',
      'content':
          'Teaching English to beginners is so rewarding! 📚 Today we practiced basic greetings and introductions. Everyone did great!',
      'likes': 15,
      'comments': 7,
      'timeAgo': '6 hours ago',
      'avatar': 'https://via.placeholder.com/50',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      title: 'Home',
      child: Stack(
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
                itemCount: _feedItems.length,
                itemBuilder: (context, index) {
                  final item = _feedItems[index];
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

  Widget _buildFeedCard(Map<String, dynamic> item) {
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
                  backgroundImage: NetworkImage(item['avatar']),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['userName'],
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
                                  item['userRole'] == 'Tutor'
                                      ? Colors.purple.withOpacity(0.1)
                                      : Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              item['userRole'],
                              style: TextStyle(
                                fontSize: 12,
                                color:
                                    item['userRole'] == 'Tutor'
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
                              item['language'],
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
                  item['timeAgo'],
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Content
            Text(
              item['content'],
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
            const SizedBox(height: 16),
            // Action buttons
            Row(
              children: [
                _buildActionButton(
                  icon: Icons.favorite_border,
                  label: '${item['likes']}',
                  onTap: () {
                    setState(() {
                      item['likes']++;
                    });
                  },
                ),
                const SizedBox(width: 24),
                _buildActionButton(
                  icon: Icons.chat_bubble_outline,
                  label: '${item['comments']}',
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
