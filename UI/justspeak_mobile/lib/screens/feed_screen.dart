import 'package:flutter/material.dart';
import 'package:frontend/layouts/master_screen.dart';
import 'package:frontend/widgets/posts_widget.dart';
import 'package:frontend/screens/add_post_screen.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      title: 'Home',
      child: Stack(
        children: [
          // Posts List
          Positioned.fill(child: PostsListWidget()),
          // Add Post Button (FloatingActionButton)
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CreatePostScreen()),
                );
              },
              backgroundColor: Colors.purple,
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
