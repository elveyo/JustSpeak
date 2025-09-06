import 'package:flutter/material.dart';
import 'package:frontend/models/language_level.dart';
import 'package:frontend/models/student.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/layouts/master_screen.dart';
import 'package:frontend/screens/login_screen.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:provider/provider.dart';

class StudentProfileScreen extends StatefulWidget {
  final int id;
  const StudentProfileScreen({super.key, required this.id});

  @override
  State<StudentProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  Student? _student;

  @override
  void initState() {
    super.initState();
    _fetchStudentData(widget.id);
  }

  Future<void> _fetchStudentData(int id) async {
    print(widget.id);
    print(AuthService().user!.id);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      final student = await userProvider.getStudentData(id);
      setState(() {
        _student = student;
      });
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to load student data. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      title: 'Profile',
      child:
          _student == null
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 40,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Theme.of(context).colorScheme.secondary,
                                const Color.fromARGB(255, 210, 83, 125),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              const CircleAvatar(
                                radius: 45,
                                backgroundImage: NetworkImage(
                                  "https://i.pravatar.cc/150?img=11",
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                _student!.user.firstName,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "${_student!.languages.map((lang) => lang.language).join(' & ')} Student",
                                style: const TextStyle(color: Colors.white70),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildTabButton("ABOUT", true),
                                  const SizedBox(width: 10),
                                  _buildTabButton("POSTS", false),
                                  const SizedBox(width: 10),
                                ],
                              ),

                              // Add logout icon button
                              // Move the logout button to the top right using a Stack and Positioned widget
                            ],
                          ),
                        ),

                        // Sign out button in the top right if viewing own profile
                        Positioned(
                          top: 8,
                          right: 8,
                          child: IconButton(
                            icon: const Icon(Icons.logout, color: Colors.white),
                            tooltip: 'Logout',
                            onPressed: () async {
                              // Clear token and navigate to login
                              await AuthService().logout();
                              if (mounted) {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (_) => const LoginScreen(),
                                  ),
                                  (route) => false,
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    // About sekcija
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 8.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 6),
                          Text(
                            _student!.user.bio,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 20),

                          const Text(
                            "Languages & Progress",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple,
                            ),
                          ),
                          const SizedBox(height: 10),

                          for (var lang in _student!.languages)
                            _buildLanguageLevelWidget(lang),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
    );
  }

  static Widget _buildTabButton(String text, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.transparent,
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isActive ? Colors.purple : Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  static Widget _buildLanguageLevelWidget(LanguageLevel level) {
    final progress = level.points / level.maxPoints;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${level.language} (${level.level})",
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: Colors.grey[300],
            color: Colors.purple,
            borderRadius: BorderRadius.circular(10),
          ),
          const SizedBox(height: 4),
          Text(
            "${level.points}/${level.maxPoints} points",
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
