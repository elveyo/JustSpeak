import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/models/comment.dart';
import 'package:frontend/providers/post_provider.dart';
import 'package:frontend/screens/add_post_screen.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../models/post.dart';
import '../screens/tutor_profile_screen.dart';
import '../screens/student_profile_screen.dart';
import 'user_avatar.dart';

class FeedCard extends StatefulWidget {
  final Post item;
  final Function(int postId) onLike;
  final VoidCallback? onRefresh; // Callback to refresh the list

  const FeedCard({
    Key? key,
    required this.item,
    required this.onLike,
    this.onRefresh,
  }) : super(key: key);

  @override
  State<FeedCard> createState() => _FeedCardState();
}

class _FeedCardState extends State<FeedCard> {
  final TextEditingController _commentController = TextEditingController();

  List<Comment> _comments = [];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<List<Comment>> _createPostComment(int postId, String content) async {
    try {
      final postProvider = Provider.of<PostProvider>(context, listen: false);
      await postProvider.postComment(postId, content);
      
      // Instantly update comment count
      setState(() {
        widget.item.numOfComments++;
      });
      
      // Fetch updated comments list
      await _fetchComments(postId);
      setState(() {});
      return _comments;
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to post comment: $e')));
      return [];
    }
  }

  Future<void> _fetchComments(int postId) async {
    try {
      final postProvider = Provider.of<PostProvider>(context, listen: false);
      final result = await postProvider.getComments(postId);
      setState(() {
        _comments = result.items!;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to fetch comments: $e')));
    }
  }

  void _showCommentsModal(BuildContext context) async {
    await _fetchComments(widget.item.id);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return _CommentsModal(
              comments: _comments,
              commentController: _commentController,
              onAddComment: (String text) async {
                if (text.trim().isEmpty) return _comments;
                final updated = await _createPostComment(widget.item.id, text);
                _commentController.clear();
                setState(() {
                  _comments = updated;
                });
                setModalState(() {
                  // Update modal state
                });
                return updated;
              },
            );
          },
        );
      },
    ).then((_) {
      // Refresh when modal closes to ensure comment count is updated
      setState(() {});
    });
  }

  void _showDeleteDialog(BuildContext context, Post post) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Post'),
          content: const Text(
            'Are you sure you want to delete this post? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  final postProvider = Provider.of<PostProvider>(
                    context,
                    listen: false,
                  );
                  // Use the delete method from BaseProvider
                  await postProvider.delete(post.id);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Post deleted successfully'),
                      ),
                    );
                    // Refresh the feed
                    widget.onRefresh?.call();
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to delete post: $e')),
                    );
                  }
                }
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

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
            GestureDetector(
              onTap: () {
                if (item.userRole == 'Tutor') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => TutorProfileScreen(id: item.authorId),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => StudentProfileScreen(id: item.authorId),
                    ),
                  );
                }
              },
              child: Row(
                children: [
                  UserAvatar(
                    radius: 20,
                    imageUrl: item.authorImageUrl,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            item.authorName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
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
                  ),
                  const SizedBox(width: 8),
                  Text(
                    timeago.format(DateTime.parse(item.createdAt)),
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  // Show 3 dots menu if current user is the creator
                  if (AuthService().userId == item.authorId) ...[
                    const SizedBox(width: 8),
                    PopupMenuButton<String>(
                      icon: const Icon(
                        Icons.more_vert,
                        size: 20,
                        color: Colors.grey,
                      ),
                      onSelected: (value) {
                        if (value == 'edit') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => CreatePostScreen(post: item),
                            ),
                          );
                        } else if (value == 'delete') {
                          _showDeleteDialog(context, item);
                        }
                      },
                      itemBuilder:
                          (BuildContext context) => [
                            const PopupMenuItem<String>(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit, size: 18),
                                  SizedBox(width: 8),
                                  Text('Edit'),
                                ],
                              ),
                            ),
                            const PopupMenuItem<String>(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.delete,
                                    size: 18,
                                    color: Colors.red,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                          ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),
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
            Text(
              item.content,
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
            const SizedBox(height: 16),
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
                      widget.onLike(item.id);
                    });
                  },
                ),
                const SizedBox(width: 24),
                _buildActionButton(
                  icon: Icons.chat_bubble_outline,
                  label: '${item.numOfComments}',
                  onTap: () => _showCommentsModal(context),
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
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[700]),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(color: Colors.grey[700])),
        ],
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
}

class _CommentsModal extends StatefulWidget {
  final List<Comment> comments;
  final TextEditingController commentController;
  final Future<List<Comment>> Function(String) onAddComment;

  const _CommentsModal({
    Key? key,
    required this.comments,
    required this.commentController,
    required this.onAddComment,
  }) : super(key: key);

  @override
  State<_CommentsModal> createState() => _CommentsModalState();
}

class _CommentsModalState extends State<_CommentsModal> {
  late List<Comment> _comments;

  @override
  void initState() {
    super.initState();
    _comments = widget.comments;
  }

  @override
  void didUpdateWidget(covariant _CommentsModal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.comments != widget.comments) {
      setState(() {
        _comments = widget.comments;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.95,
      minChildSize: 0.35,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 12,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Drag handle and close
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      "Comments",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const Divider(height: 1),
              Expanded(
                child:
                    _comments.isEmpty
                        ? const Center(
                          child: Text(
                            "No comments yet.",
                            style: TextStyle(
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        )
                        : ListView.builder(
                          controller: scrollController,
                          itemCount: _comments.length,
                          itemBuilder: (context, idx) {
                            final comment = _comments[idx];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12.0,
                                horizontal: 16.0,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  UserAvatar(
                                    radius: 16,
                                    imageUrl: comment.authorImage,
                                    backgroundColor: Colors.grey[300],
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              comment.authorName ?? "Unknown",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              timeago.format(comment.createdAt),
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 11,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          comment.content ?? "",
                                          style: const TextStyle(fontSize: 13),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 20,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: widget.commentController,
                        decoration: InputDecoration(
                          hintText: "Add a comment...",
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                        ),
                        minLines: 1,
                        maxLines: 3,
                        onSubmitted: (text) async {
                          if (text.trim().isNotEmpty) {
                            final updated = await widget.onAddComment(text);
                            if (mounted) {
                              setState(() {
                                _comments = updated;
                              });
                            }
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.send, color: Colors.purple),
                      onPressed: () async {
                        final text = widget.commentController.text;
                        if (text.trim().isNotEmpty) {
                          final updated = await widget.onAddComment(text);
                          if (mounted) {
                            setState(() {
                              _comments = updated;
                            });
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
