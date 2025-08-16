import 'package:flutter/material.dart';
import 'package:frontend/layouts/master_screen.dart';
import 'package:frontend/models/language.dart';
import 'package:frontend/models/languale_level.dart';
import 'package:frontend/models/session.dart';
import 'package:frontend/providers/language_level_provider.dart';
import 'package:frontend/providers/language_provider.dart';
import 'package:frontend/providers/session_provider.dart';
import 'package:frontend/screens/add_session_screen.dart';
import 'package:frontend/screens/video_call_screen.dart';
import 'package:provider/provider.dart';

class SessionsScreen extends StatefulWidget {
  const SessionsScreen({super.key});

  @override
  State<SessionsScreen> createState() => _SessionsScreenState();
}

class _SessionsScreenState extends State<SessionsScreen> {
  int? selectedLanguage;
  int? selectedLevel;

  List<Language>? languages;
  List<LanguageLevel>? languageLevels;
  List<Session>? sessions;

  @override
  void initState() {
    super.initState();
    _loadLanguagesAndLevels();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    final sessionProvider = Provider.of<SessionProvider>(
      context,
      listen: false,
    );
    dynamic filter;
    if (selectedLanguage != null && selectedLevel != null) {
      filter = {"languageId": selectedLanguage, "levelId": selectedLevel};
    }

    try {
      final fetchedSessions = await sessionProvider.get(filter: filter);
      setState(() {
        sessions = fetchedSessions.items;
      });
    } catch (error) {}
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
      // Optionally handle error, e.g. show a snackbar or log
    }
  }

  Future<void> _joinSession(String channelName) async {
    print("sdadasd");
    final sessionProvider = Provider.of<SessionProvider>(
      context,
      listen: false,
    );
    try {
      String token = await sessionProvider.getToken(channelName);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => VideoCallScreen(channelName: channelName, token: token),
        ),
      );
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      title: "Sessions",
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  width: 180, // Set a fixed width
                  height: 40, // Set a fixed height
                  child: DropdownButtonFormField<int>(
                    value:
                        (languages != null && languages!.isNotEmpty)
                            ? languages!.first.id
                            : null,
                    items:
                        (languages ?? [])
                            .map(
                              (lang) => DropdownMenuItem(
                                value: lang.id,
                                child: Text(lang.name),
                              ),
                            )
                            .toList(),
                    onChanged: (val) {
                      setState(() {
                        selectedLanguage = val!;
                        _loadSessions();
                      });
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10, // Increased horizontal padding
                        vertical: 5, // Increased vertical padding
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  width: 180, // Set a fixed width
                  height: 40, // Set a fixed height
                  child: DropdownButtonFormField<int>(
                    value:
                        (languageLevels != null && languageLevels!.isNotEmpty)
                            ? languageLevels!.first.id
                            : null,
                    items:
                        (languageLevels ?? [])
                            .map(
                              (level) => DropdownMenuItem(
                                value: level.id,
                                child: Text(level.name),
                              ),
                            )
                            .toList(),
                    onChanged: (val) {
                      setState(() {
                        selectedLevel = val!;
                        _loadSessions();
                      });
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 5,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.add, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => CreateSessionScreen(
                              languages: languages,
                              levels: languageLevels,
                            ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          (sessions == null || sessions?.isEmpty == true)
              ? Center(
                child: Text(
                  "No sessions available.",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              )
              : Expanded(
                child: ListView.builder(
                  itemCount: sessions?.length ?? 0,
                  itemBuilder: (context, index) {
                    final session = sessions![index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        session.language!,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      Text(
                                        session.level!,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '${session.numOfUsers}/4',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  flex: 6, // 60% of the Row
                                  child: Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children:
                                        session.tags
                                            .map<Widget>(
                                              (tag) => Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 3,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: Color(
                                                    int.parse(
                                                      tag.color.replaceFirst(
                                                        '#',
                                                        '0xff',
                                                      ),
                                                    ),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                  tag.name,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 11,
                                                  ),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                  ),
                                ),
                                const Spacer(),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF6A1B9A),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 8,
                                    ),
                                  ),
                                  onPressed: () {
                                    _joinSession(session.channelName!);
                                  },
                                  child: const Text(
                                    'JOIN',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
        ],
      ),
    );
  }
}
