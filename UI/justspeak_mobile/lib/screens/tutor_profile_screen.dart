import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/models/tutor.dart';
import 'package:frontend/models/certificate.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/providers/post_provider.dart';
import 'package:frontend/providers/certificate_provider.dart';
import 'package:frontend/screens/book_session_screen.dart';
import 'package:frontend/screens/certificate_screen.dart';
import 'package:frontend/screens/login_screen.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/widgets/posts_widget.dart';
import 'package:provider/provider.dart';

class TutorProfileScreen extends StatefulWidget {
  final int id;

  const TutorProfileScreen({Key? key, required this.id}) : super(key: key);

  @override
  _TutorProfilePageState createState() => _TutorProfilePageState();
}

class _TutorProfilePageState extends State<TutorProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  late UserProvider _userProvider;
  late PostProvider _postProvider;
  late CertificateProvider _certificateProvider;
  late Future<Tutor> _tutorFuture;

  // Theme Colors
  final Color _primaryColor = const Color(0xFFB000FF);
  final Color _backgroundColor = const Color(0xFFF7F7FB);
  final Color _textColor = const Color(0xFF2D2D2D);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _userProvider = UserProvider();
    _postProvider = PostProvider();
    _certificateProvider = CertificateProvider();
    _tutorFuture = _userProvider.getTutorData(widget.id);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: FutureBuilder<Tutor>(
        future: _tutorFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('No data found'));
          }

          final tutor = snapshot.data!;
          final user = tutor.user;

          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              _buildSliverAppBar(context, user.fullName, user.imageUrl, tutor.hasSchedule),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTutorInfo(user.fullName, tutor.price),
                      const SizedBox(height: 24),
                      _buildStatsRow(tutor.studentCount, tutor.sessionCount),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    controller: _tabController,
                    labelColor: _primaryColor,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: _primaryColor,
                    indicatorWeight: 3,
                    labelStyle: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                    tabs: const [
                      Tab(text: "About"),
                      Tab(text: "Posts"),
                    ],
                  ),
                ),
                pinned: true,
              ),
              SliverFillRemaining(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildAboutTab(tutor),
                    _buildPostsTab(tutor.user.id),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSliverAppBar(
      BuildContext context, String displayName, String? avatarUrl, bool hasSchedule) {
    return SliverAppBar(
      expandedHeight: MediaQuery.of(context).size.height * 0.35,
      floating: false,
      pinned: true,
      backgroundColor: _primaryColor,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        if (AuthService().userId == widget.id)
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              AuthService().logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Background Pattern or Gradient
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    _primaryColor,
                    _primaryColor.withOpacity(0.8),
                  ],
                ),
              ),
            ),
            // Profile Image and Book Button
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: avatarUrl != null && avatarUrl.isNotEmpty
                          ? NetworkImage(avatarUrl)
                          : null,
                      backgroundColor: Colors.grey.shade200,
                      child: avatarUrl == null || avatarUrl.isEmpty
                          ? const Icon(Icons.person, size: 60, color: Colors.grey)
                          : null,
                    ),
                  ),
                  // Only show book button if not viewing own profile
                  if (AuthService().userId != widget.id) ...[
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: hasSchedule
                          ? () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => TutorBookingScreen(tutorId: widget.id),
                                ),
                              );
                            }
                          : null, // Disabled when no schedule
                      icon: const Icon(Icons.calendar_today, size: 18),
                      label: const Text(
                        "Book Session",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: hasSchedule ? Colors.white : Colors.grey.shade300,
                        foregroundColor: hasSchedule ? _primaryColor : Colors.grey.shade600,
                        disabledBackgroundColor: Colors.grey.shade300,
                        disabledForegroundColor: Colors.grey.shade600,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        elevation: hasSchedule ? 4 : 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                    ),
                    if (!hasSchedule)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          "No available sessions",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTutorInfo(String name, double? price) {
    String priceText = price != null ? "\$${price.toStringAsFixed(0)}/hr" : "--";
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: _textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.school, size: 18, color: _primaryColor),
                      const SizedBox(width: 4),
                      Text(
                        "Tutor",
                        style: TextStyle(
                          color: _primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                priceText,
                style: TextStyle(
                  color: _primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsRow(int students, int sessions) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem("Students", "$students"),
          _buildVerticalDivider(),
          _buildStatItem("Sessions", "$sessions"),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: _primaryColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 30,
      width: 1,
      color: Colors.grey.shade200,
    );
  }

  Widget _buildAboutTab(Tutor tutor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "About Me",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            tutor.user.bio ?? "No bio available.",
            style: TextStyle(
              fontSize: 15,
              height: 1.6,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "Languages",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: tutor.languages
                .map((l) => _buildChip(l.name))
                .toList(),
          ),
          const SizedBox(height: 24),
          _buildCertificatesSection(tutor.certificates),
        ],
      ),
    );
  }

  Widget _buildCertificatesSection(List<Certificate> certificates) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Certificates",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (AuthService().userId == widget.id)
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                color: _primaryColor,
                onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CertificateScreen()),
                );
                if (result == true) {
                  setState(() {
                    _tutorFuture = _userProvider.getTutorData(widget.id);
                  });
                }
              },
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (certificates.isEmpty)
          Text(
            "No certificates added yet.",
            style: TextStyle(color: Colors.grey.shade600),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: certificates.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final cert = certificates[index];
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    // Certificate Image - Always show
                    GestureDetector(
                      onTap: () {
                        if (cert.imageUrl != null && cert.imageUrl!.isNotEmpty) {
                          _showCertificateImage(context, cert.imageUrl!, cert.name);
                        }
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: cert.imageUrl != null && cert.imageUrl!.isNotEmpty
                            ? _buildCertificateImage(cert.imageUrl!)
                            : Container(
                                width: 80,
                                height: 80,
                                color: Colors.grey.shade200,
                                child: const Icon(
                                  Icons.workspace_premium,
                                  color: Colors.amber,
                                  size: 40,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        cert.name,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    if (AuthService().userId == widget.id) ...[
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CertificateScreen(certificate: cert),
                          ),
                        );
                        if (result == true) {
                          setState(() {
                            _tutorFuture = _userProvider.getTutorData(widget.id);
                          });
                        }
                      },
                    ),
                     IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () async {
                         try {
                           await _certificateProvider.delete(cert.id);
                           setState(() {
                             _tutorFuture = _userProvider.getTutorData(widget.id);
                           });
                         } catch (e) {
                           ScaffoldMessenger.of(context).showSnackBar(
                             SnackBar(content: Text("Error deleting certificate: $e")),
                           );
                         }
                      },
                    ),
                    ],
                  ],
                ),
              );
            },
          ),
      ],
    );
  }



  Widget _buildChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: _primaryColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _primaryColor.withOpacity(0.2)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: _primaryColor,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildCertificateImage(String imageUrl) {
    // Check if it's base64
    if (!imageUrl.startsWith('http')) {
      try {
        final base64RegExp = RegExp(r'data:image/[^;]+;base64,');
        String pureBase64 = imageUrl.replaceAll(base64RegExp, '');
        final bytes = base64Decode(pureBase64);
        return Image.memory(
          bytes,
          width: 80,
          height: 80,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            width: 80,
            height: 80,
            color: Colors.grey.shade200,
            child: const Icon(
              Icons.workspace_premium,
              color: Colors.amber,
              size: 40,
            ),
          ),
        );
      } catch (e) {
        return Container(
          width: 80,
          height: 80,
          color: Colors.grey.shade200,
          child: const Icon(
            Icons.workspace_premium,
            color: Colors.amber,
            size: 40,
          ),
        );
      }
    } else {
      return Image.network(
        imageUrl,
        width: 80,
        height: 80,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: 80,
          height: 80,
          color: Colors.grey.shade200,
          child: const Icon(
            Icons.workspace_premium,
            color: Colors.amber,
            size: 40,
          ),
        ),
      );
    }
  }

  void _showCertificateImage(BuildContext context, String imageUrl, String name) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8,
                maxWidth: MediaQuery.of(context).size.width * 0.9,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: !imageUrl.startsWith('http')
                    ? _buildBase64ImageLarge(imageUrl)
                    : Image.network(
                        imageUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => Container(
                          padding: const EdgeInsets.all(40),
                          color: Colors.grey.shade200,
                          child: const Icon(
                            Icons.broken_image,
                            size: 80,
                            color: Colors.grey,
                          ),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 32),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBase64ImageLarge(String base64String) {
    try {
      final base64RegExp = RegExp(r'data:image/[^;]+;base64,');
      String pureBase64 = base64String.replaceAll(base64RegExp, '');
      final bytes = base64Decode(pureBase64);
      return Image.memory(
        bytes,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => Container(
          padding: const EdgeInsets.all(40),
          color: Colors.grey.shade200,
          child: const Icon(
            Icons.broken_image,
            size: 80,
            color: Colors.grey,
          ),
        ),
      );
    } catch (e) {
      return Container(
        padding: const EdgeInsets.all(40),
        color: Colors.grey.shade200,
        child: const Icon(
          Icons.broken_image,
          size: 80,
          color: Colors.grey,
        ),
      );
    }
  }

  Widget _buildPostsTab(int authorId) {
    return PostsListWidget(userId: authorId);
  }

  Widget _buildBottomBookingBar(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => TutorBookingScreen(tutorId: widget.id),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Book a Session",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: const Color(0xFFF7F7FB), // Match background color
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
