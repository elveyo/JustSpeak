import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/layouts/master_screen.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/screens/add_post_screen.dart';
import 'package:frontend/screens/student_profile_screen.dart';
import 'package:frontend/screens/tutor_profile_screen.dart';
import 'package:frontend/widgets/posts_widget.dart';
import 'package:provider/provider.dart';
import '../widgets/user_avatar.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List<User> _searchResults = [];
  bool _isSearching = false;
  bool _showResults = false;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _performSearch();
    });
  }

  Future<void> _performSearch() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _showResults = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _showResults = true;
    });

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final result = await userProvider.searchUsers(query);
      if (mounted) {
        setState(() {
          _searchResults = result.items ?? [];
          _isSearching = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _searchResults = [];
          _isSearching = false;
        });
      }
    }
  }

  void _navigateToProfile(User user) {
    _searchController.clear();
    _searchFocusNode.unfocus();
    setState(() {
      _showResults = false;
      _searchResults = [];
    });

    if (user.role.toLowerCase() == 'tutor') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => TutorProfileScreen(id: user.id)),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => StudentProfileScreen(id: user.id)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      title: 'Home',
      child: GestureDetector(
        onTap: () {
          // Close search results when tapping outside
          if (_showResults) {
            _searchFocusNode.unfocus();
            setState(() {
              _showResults = false;
            });
          }
        },
        child: Stack(
          children: [
            // Posts List
            Positioned.fill(
              child: Column(
                children: [
                  // Search Bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Column(
                      children: [
                        // Search Input
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _searchController,
                            focusNode: _searchFocusNode,
                            onChanged: (value) {
                              setState(() {});
                            },
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Search for tutors and students...',
                              hintStyle: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                              prefixIcon: Container(
                                margin: const EdgeInsets.all(12),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.purple.shade400,
                                      Colors.purple.shade600,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.search,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              suffixIcon:
                                  _searchController.text.isNotEmpty
                                      ? IconButton(
                                        icon: Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[100],
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.close,
                                            size: 18,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        onPressed: () {
                                          _searchController.clear();
                                          _searchFocusNode.unfocus();
                                          setState(() {
                                            _showResults = false;
                                            _searchResults = [];
                                          });
                                        },
                                      )
                                      : null,
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade200,
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: Colors.purple.shade300,
                                  width: 2,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                            ),
                            onTap: () {
                              if (_searchController.text.isNotEmpty &&
                                  _searchResults.isNotEmpty) {
                                setState(() {
                                  _showResults = true;
                                });
                              }
                            },
                          ),
                        ),
                        // Search Results Dropdown
                        if (_showResults)
                          Container(
                            constraints: const BoxConstraints(maxHeight: 350),
                            margin: const EdgeInsets.only(top: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.purple.withOpacity(0.15),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child:
                                _isSearching
                                    ? Padding(
                                      padding: const EdgeInsets.all(32),
                                      child: Center(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            CircularProgressIndicator(
                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                Colors.purple.shade400,
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            Text(
                                              'Searching...',
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                    : _searchResults.isEmpty
                                    ? Padding(
                                      padding: const EdgeInsets.all(32),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.search_off_rounded,
                                            size: 48,
                                            color: Colors.grey[300],
                                          ),
                                          const SizedBox(height: 12),
                                          Text(
                                            'No users found',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Try a different search term',
                                            style: TextStyle(
                                              color: Colors.grey[400],
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                    : ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: ListView.separated(
                                        shrinkWrap: true,
                                        padding: const EdgeInsets.symmetric(vertical: 8),
                                        itemCount: _searchResults.length,
                                        separatorBuilder: (context, index) => Divider(
                                          height: 1,
                                          thickness: 1,
                                          color: Colors.grey[100],
                                          indent: 72,
                                        ),
                                        itemBuilder: (context, index) {
                                          final user = _searchResults[index];
                                          return _buildUserResultItem(user);
                                        },
                                      ),
                                    ),
                          ),
                      ],
                    ),
                  ),
                  // Posts
                  Expanded(child: PostsListWidget()),
                ],
              ),
            ),
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
      ),
    );
  }

  Widget _buildUserResultItem(User user) {
    final isTutor = user.role.toLowerCase() == 'tutor';
    return InkWell(
      onTap: () => _navigateToProfile(user),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            // User Avatar with gradient border
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: isTutor
                      ? [Colors.purple.shade300, Colors.purple.shade600]
                      : [Colors.blue.shade300, Colors.blue.shade600],
                ),
                boxShadow: [
                  BoxShadow(
                    color: (isTutor ? Colors.purple : Colors.blue).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(2.5),
              child: CircleAvatar(
                radius: 26,
                backgroundColor: Colors.white,
                child: UserAvatar(
                  radius: 24,
                  imageUrl: user.imageUrl,
                  backgroundColor: isTutor ? Colors.purple[50] : Colors.blue[50],
                  fallbackIcon: isTutor ? Icons.school : Icons.person,
                ),
              ),
            ),
            const SizedBox(width: 14),
            // User Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.fullName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isTutor
                                ? [Colors.purple.shade100, Colors.purple.shade50]
                                : [Colors.blue.shade100, Colors.blue.shade50],
                          ),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isTutor
                                ? Colors.purple.shade200
                                : Colors.blue.shade200,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isTutor ? Icons.school_rounded : Icons.person_rounded,
                              size: 14,
                              color: isTutor ? Colors.purple.shade700 : Colors.blue.shade700,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              isTutor ? 'Tutor' : 'Student',
                              style: TextStyle(
                                color:
                                    isTutor ? Colors.purple.shade700 : Colors.blue.shade700,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Arrow Icon
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.grey[400],
                size: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
