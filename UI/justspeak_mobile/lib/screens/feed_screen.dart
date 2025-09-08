import 'package:flutter/material.dart';
import 'package:frontend/layouts/master_screen.dart';
import 'package:frontend/widgets/posts_widget.dart';

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
    return MasterScreen(title: 'Home', child: PostsListWidget());
  }
}
