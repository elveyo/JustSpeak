import 'package:flutter/material.dart';
import 'package:frontend/layouts/master_screen.dart';
import 'package:frontend/models/post.dart';
import 'package:frontend/models/search_result.dart';
import 'package:frontend/providers/post_provider.dart';
import 'package:frontend/screens/add_post_screen.dart';
import 'package:frontend/screens/student_profile_screen.dart';
import 'package:frontend/screens/tutor_profile_screen.dart';
import 'package:frontend/widgets/post_card.dart';
import 'package:frontend/widgets/posts_widget.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:timeago/timeago.dart' as timeago;

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
