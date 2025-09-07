import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:frontend/models/language.dart';
import 'package:frontend/models/level.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/providers/language_level_provider.dart';
import 'package:frontend/providers/language_provider.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/screens/feed_screen.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UserOnboardingScreen extends StatefulWidget {
  final User user;
  const UserOnboardingScreen({super.key, required this.user});

  @override
  State<UserOnboardingScreen> createState() => _UserOnboardingScreenState();
}

class _UserOnboardingScreenState extends State<UserOnboardingScreen> {
  int _currentStep = 0;

  List<Language>? languages;
  List<Level>? languageLevels;

  List<Map<String, int>> selectedLanguages = [];

  String? bio;
  String? profileImageBase64; // base64 string for BE and display

  int? tempLang;
  int? tempLevel;

  bool _isRegistering = false;

  @override
  void initState() {
    super.initState();
    _loadLanguagesAndLevels();
  }

  Future<void> register() async {
    // Build the request object
    final request = {
      "bio": bio,
      "roleId": widget.user.role == 'tutor' ? 2 : 3,
      "firstName": widget.user.firstName,
      "lastName": widget.user.lastName,
      "email": widget.user.email,
      "password": widget.user.password,
      "languages":
          selectedLanguages
              .map(
                (lang) => {
                  "languageId": lang["languageId"],
                  "levelId": lang["levelId"],
                },
              )
              .toList(),
      "imageUrl": profileImageBase64, // send as base64
    };

    try {
      setState(() {
        _isRegistering = true;
      });
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      String token = await userProvider.register(request);
      AuthService().saveToken(token);
    } catch (err) {
      rethrow;
    } finally {
      if (mounted) {
        setState(() {
          _isRegistering = false;
        });
      }
    }
  }

  Future<void> _loadLanguagesAndLevels() async {
    try {
      final languageProvider = Provider.of<LanguageProvider>(
        context,
        listen: false,
      );
      final languageLevelProvider = Provider.of<LanguageLevelProvider>(
        context,
        listen: false,
      );
      final langs = await languageProvider.get();
      final levels = await languageLevelProvider.get();
      setState(() {
        languages = langs.items;
        languageLevels = levels.items;
        // Set default tempLang and tempLevel to first available if not set
        if (languages != null && languages!.isNotEmpty) {
          tempLang = languages!.first.id;
        }
        if (languageLevels != null && languageLevels!.isNotEmpty) {
          tempLevel = languageLevels!.first.id;
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occurred. Please try again later.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _nextStep() async {
    if (_currentStep < 2) {
      setState(() => _currentStep++);
    } else {
      // Finish: Call register here
      debugPrint("🎉 Onboarding complete!");
      debugPrint("Languages: $selectedLanguages");
      debugPrint("Bio: $bio");
      await register();
      // After registration, navigate to the FeedScreen
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const FeedScreen()),
          (route) => false,
        );
      }
    }
  }

  void _backStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  bool get _canGoNext {
    if (_currentStep == 1) {
      // Must have at least one language to go next
      return selectedLanguages.isNotEmpty;
    }
    if (_currentStep == 2) {
      // Must have image and bio to finish
      return (profileImageBase64 != null && profileImageBase64!.isNotEmpty) &&
          (bio != null && bio!.trim().isNotEmpty);
    }
    // For welcome step, always true (but button not shown)
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // There are now 3 steps: 0 (welcome), 1 (languages), 2 (profile)
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        toolbarHeight: 20,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // progress
            LinearProgressIndicator(
              value: (_currentStep + 1) / 3,
              color: Colors.deepPurple,
              backgroundColor: Colors.grey[300],
              minHeight: 8,
              borderRadius: BorderRadius.circular(10),
            ),
            const SizedBox(height: 20),

            // content
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: _buildStepContent(),
              ),
            ),

            // navigation
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentStep > 0)
                  TextButton(onPressed: _backStep, child: const Text("Back")),
                // Removed skip button
                if (_currentStep != 0)
                  ElevatedButton(
                    onPressed:
                        _isRegistering || !_canGoNext
                            ? null
                            : () async {
                              await _nextStep();
                            },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _canGoNext ? Colors.deepPurple : Colors.grey[400],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child:
                        _isRegistering
                            ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                            : Text(_currentStep == 2 ? "Finish" : "Next"),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return widget.user.role == 'tutor'
            ? TutorWelcomeStep(onNext: _nextStep)
            : StudentWelcomeStep(onNext: _nextStep);
      case 1:
        return _buildLanguagesStep();
      case 2:
        return _buildProfileStep();
      default:
        return const SizedBox();
    }
  }

  // STEP 1: Languages + Levels (can add multiple)
  Widget _buildLanguagesStep() {
    return StatefulBuilder(
      key: const ValueKey(1),
      builder: (context, setInner) {
        // Ensure tempLang and tempLevel are valid
        if (languages != null && languages!.isNotEmpty) {
          if (tempLang == null || !languages!.any((l) => l.id == tempLang)) {
            tempLang = languages!.first.id;
          }
        }
        if (languageLevels != null && languageLevels!.isNotEmpty) {
          if (tempLevel == null ||
              !languageLevels!.any((l) => l.id == tempLevel)) {
            tempLevel = languageLevels!.first.id;
          }
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.user.role == 'tutor'
                  ? "🌍  Teaching Languages"
                  : "🌍  Learning Languages",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              widget.user.role == 'tutor'
                  ? "Add the languages you can teach and your proficiency level."
                  : "Add the languages you want to learn and your current level.",
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 20),

            DropdownButtonFormField<int>(
              value: tempLang,
              decoration: const InputDecoration(
                labelText: "Language",
                border: OutlineInputBorder(),
              ),
              items:
                  languages
                      ?.map(
                        (e) => DropdownMenuItem<int>(
                          value: e.id,
                          child: Text(e.name),
                        ),
                      )
                      .toList(),
              onChanged: (val) {
                setInner(() => tempLang = val);
              },
            ),
            const SizedBox(height: 12),

            DropdownButtonFormField<int>(
              decoration: const InputDecoration(
                labelText: "Level",
                border: OutlineInputBorder(),
              ),
              value: tempLevel,
              items:
                  languageLevels
                      ?.map(
                        (e) => DropdownMenuItem<int>(
                          value: e.id,
                          child: Text(e.name),
                        ),
                      )
                      .toList(),
              onChanged: (val) {
                setInner(() => tempLevel = val);
              },
            ),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    if (tempLang != null &&
                        tempLevel != null &&
                        languages != null &&
                        languageLevels != null) {
                      // Prevent duplicate language entries
                      if (!selectedLanguages.any(
                        (entry) => entry['languageId'] == tempLang,
                      )) {
                        setState(() {
                          selectedLanguages.add({
                            "languageId": tempLang!,
                            "levelId": tempLevel!,
                          });
                        });
                        setInner(() {});
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('You already added this language.'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Add"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    side: const BorderSide(
                      color: Colors.deepPurple, // border color
                      width: 2, // border width
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: selectedLanguages.length,
                itemBuilder: (ctx, i) {
                  final entry = selectedLanguages[i];
                  final lang = languages?.firstWhere(
                    (l) => l.id == entry['languageId'],
                  );
                  final level = languageLevels?.firstWhere(
                    (l) => l!.id == entry['levelId'],
                  );
                  return Card(
                    child: ListTile(
                      title: Text("${lang?.name ?? ''} - ${level?.name ?? ''}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            selectedLanguages.removeAt(i);
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  // STEP 2: Modern Profile (image + bio)
  Widget _buildProfileStep() {
    return Center(
      key: const ValueKey(2),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.auto_awesome, size: 32, color: Colors.deepPurple),
                SizedBox(width: 8),
                Text(
                  "Introduce Yourself!",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              widget.user.role == 'tutor'
                  ? "Tell us something about yourself. Share your look, interests, or fun facts!"
                  : "Tell us about your learning goals, interests, or fun facts!",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, color: Colors.black54),
            ),
            const SizedBox(height: 24),

            GestureDetector(
              onTap: () async {
                final ImagePicker picker = ImagePicker();
                final XFile? image = await picker.pickImage(
                  source: ImageSource.gallery,
                );
                if (image != null) {
                  final bytes = await image.readAsBytes();
                  // Always encode as base64 and store in profileImageBase64
                  final base64Image =
                      'data:image/${image.path.split('.').last};base64,${base64Encode(bytes)}';
                  setState(() => profileImageBase64 = base64Image);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Colors.deepPurple, Colors.purpleAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.3),
                      blurRadius: 15,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white,
                  backgroundImage:
                      profileImageBase64 != null
                          ? MemoryImage(_decodeBase64(profileImageBase64!))
                          : null,
                  child:
                      profileImageBase64 == null
                          ? const Icon(
                            Icons.camera_alt,
                            size: 40,
                            color: Colors.deepPurple,
                          )
                          : null,
                ),
              ),
            ),

            const SizedBox(height: 32),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  maxLines: null, // allow any length
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Write something about yourself...",
                  ),
                  onChanged: (val) => setState(() => bio = val),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper to decode base64 string (with/without data:image/...;base64, prefix)
  static Uint8List _decodeBase64(String base64String) {
    try {
      final regex = RegExp(r'data:image/[^;]+;base64,');
      final cleaned = base64String.replaceFirst(regex, '');
      return base64Decode(cleaned);
    } catch (e) {
      // fallback: try to decode as is
      try {
        return base64Decode(base64String);
      } catch (_) {
        return Uint8List(0);
      }
    }
  }
}

// Welcome widget for tutors
class TutorWelcomeStep extends StatelessWidget {
  final VoidCallback onNext;
  const TutorWelcomeStep({Key? key, required this.onNext}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      key: const ValueKey('welcome-tutor'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.school, size: 64, color: Colors.deepPurple),
            const SizedBox(height: 24),
            const Text(
              "Welcome to Tutor Onboarding!",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              "We're excited to have you join our community of passionate tutors. "
              "Share your skills, inspire students, and make a difference in the world of learning. "
              "Let's get started on your journey!",
              style: TextStyle(fontSize: 16, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Start",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Welcome widget for students
class StudentWelcomeStep extends StatelessWidget {
  final VoidCallback onNext;
  const StudentWelcomeStep({Key? key, required this.onNext}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      key: const ValueKey('welcome-student'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.emoji_people, size: 64, color: Colors.deepPurple),
            const SizedBox(height: 24),
            const Text(
              "Welcome to Student Onboarding!",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              "We're excited to help you on your language learning journey. "
              "Connect with amazing tutors, set your goals, and start learning today!",
              style: TextStyle(fontSize: 16, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Start",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
