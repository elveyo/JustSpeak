import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/models/language.dart';
import 'package:frontend/models/languale_level.dart';
import 'package:frontend/providers/language_level_provider.dart';
import 'package:frontend/providers/language_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class TutorOnboardingScreen extends StatefulWidget {
  const TutorOnboardingScreen({super.key});

  @override
  State<TutorOnboardingScreen> createState() => _TutorOnboardingScreenState();
}

class _TutorOnboardingScreenState extends State<TutorOnboardingScreen> {
  int _currentStep = 0;

  List<Language>? languages;
  List<LanguageLevel>? languageLevels;

  List<Map<String, String>> selectedLanguages = [];
  Map<String, List<String>> certificates = {};

  String? bio;
  String? profileImage;

  @override
  void initState() {
    super.initState();
    _loadLanguagesAndLevels();
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

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() => _currentStep++);
    } else {
      // Finish
      debugPrint("🎉 Onboarding complete!");
      debugPrint("Languages: $selectedLanguages");
      debugPrint("Certificates: $certificates");
      debugPrint("Bio: $bio");
    }
  }

  void _backStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  @override
  Widget build(BuildContext context) {
    // There are now 4 steps: 0 (welcome), 1 (languages), 2 (certificates), 3 (profile)
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
              value: (_currentStep + 1) / 4,
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
                if (_currentStep > 0 && _currentStep < 3)
                  TextButton(
                    onPressed: () => setState(() => _currentStep = 3),
                    child: const Text("Skip"),
                  ),
                if (_currentStep != 0)
                  ElevatedButton(
                    onPressed: _nextStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(_currentStep == 3 ? "Finish" : "Next"),
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
        return _buildWelcomeStep();
      case 1:
        return _buildLanguagesStep();
      case 2:
        return _buildCertificatesStep();
      case 3:
        return _buildProfileStep();
      default:
        return const SizedBox();
    }
  }

  // NEW: Welcome Step
  Widget _buildWelcomeStep() {
    return Center(
      key: const ValueKey('welcome'),
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
              onPressed: _nextStep,
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

  // STEP 1: Jezici + Leveli (može dodati više)
  Widget _buildLanguagesStep() {
    int? tempLang;
    int? tempLevel;

    return StatefulBuilder(
      key: const ValueKey(1),
      builder: (context, setInner) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "🌍  Teaching Languages",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            const Text(
              "Add the languages you can teach and your proficiency level.",
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 20),

            DropdownButtonFormField<int>(
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
              onChanged: (val) => setInner(() => tempLang = val),
            ),
            const SizedBox(height: 12),

            DropdownButtonFormField<int>(
              decoration: const InputDecoration(
                labelText: "Level",
                border: OutlineInputBorder(),
              ),
              items:
                  languageLevels
                      ?.map(
                        (e) => DropdownMenuItem<int>(
                          value: e.id,
                          child: Text(e.name),
                        ),
                      )
                      .toList(),
              onChanged: (val) => setInner(() => tempLevel = val),
            ),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    print(tempLevel);
                    print(tempLang);
                    if (tempLang != null && tempLevel != null) {
                      setState(() {
                        print("feafefefefe");

                        selectedLanguages.add({
                          "language": languages![tempLang!].name,
                          "level": languageLevels![tempLevel!].name,
                        });
                        certificates[languages![tempLang!].name] = [];
                      });
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
                  return Card(
                    child: ListTile(
                      title: Text("${entry['language']} - ${entry['level']}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            certificates.remove(entry['language']);
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

  // STEP 2: Certifikati po jeziku
  Widget _buildCertificatesStep() {
    return Column(
      key: const ValueKey(2),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "📜 Upload Certificates",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        const Text(
          "Showcase your expertise! Upload certificates that prove your knowledge.",
          style: TextStyle(fontSize: 14, color: Colors.black54),
        ),
        const SizedBox(height: 16),

        Expanded(
          child: ListView(
            children:
                selectedLanguages.map((langEntry) {
                  final lang = langEntry['language']!;
                  final certs = certificates[lang] ?? [];

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ExpansionTile(
                      title: Text(
                        lang,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            // ovdje ide image picker
                            setState(() {
                              certs.add("certificate_${certs.length + 1}.png");
                              certificates[lang] = certs;
                            });
                          },
                          icon: const Icon(Icons.upload),
                          label: const Text("Add Certificate"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        ...certs.map(
                          (c) => ListTile(
                            leading: const Icon(Icons.image),
                            title: Text(c),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  certs.remove(c);
                                  certificates[lang] = certs;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }

  // STEP 3: Moderan Profile (slika + bio)
  Widget _buildProfileStep() {
    return Center(
      key: const ValueKey(3),
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
            const Text(
              "Tell us something about yourself. Share your look, interests, or fun facts!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.black54),
            ),
            const SizedBox(height: 24),

            GestureDetector(
              onTap: () async {
                final ImagePicker picker = ImagePicker();
                final XFile? image = await picker.pickImage(
                  source: ImageSource.gallery,
                );
                if (image != null) {
                  setState(() => profileImage = image.path);
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
                  backgroundImage:
                      profileImage != null
                          ? (profileImage!.startsWith('assets/')
                              ? AssetImage(profileImage!)
                              : FileImage(File(profileImage!)) as ImageProvider)
                          : null,
                  backgroundColor: Colors.white,
                  child:
                      profileImage == null
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
                  maxLines: 5,
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
}
