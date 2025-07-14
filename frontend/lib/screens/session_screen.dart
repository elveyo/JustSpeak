import 'package:flutter/material.dart';

class SessionsScreen extends StatefulWidget {
  const SessionsScreen({super.key});

  @override
  State<SessionsScreen> createState() => _SessionsScreenState();
}

class _SessionsScreenState extends State<SessionsScreen> {
  String selectedLanguage = 'English';
  String selectedLevel = 'Intermediate';

  final List<String> languages = ['English', 'Spanish', 'French'];
  final List<String> levels = ['Beginner', 'Intermediate', 'Advanced'];

  final List<Map<String, dynamic>> sessions = [
    {
      'language': 'English',
      'level': 'Beginners',
      'participants': '3 / 4',
      'tags': ['#music', '#music', '#music'],
    },
    {
      'language': 'English',
      'level': 'Beginners',
      'participants': '3 / 4',
      'tags': ['#music', '#music', '#music'],
    },
    {
      'language': 'Spanish',
      'level': 'Beginners',
      'participants': '2 / 4',
      'tags': ['#music', '#music', '#music'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  width: 180, // Set a fixed width
                  height: 40, // Set a fixed height
                  child: DropdownButtonFormField<String>(
                    value: selectedLanguage,
                    items:
                        languages
                            .map(
                              (lang) => DropdownMenuItem(
                                value: lang,
                                child: Text(lang),
                              ),
                            )
                            .toList(),
                    onChanged: (val) {
                      setState(() {
                        selectedLanguage = val!;
                      });
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, // Increased horizontal padding
                        vertical: 10, // Increased vertical padding
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
                child: DropdownButtonFormField<String>(
                  value: selectedLevel,
                  items:
                      levels
                          .map(
                            (level) => DropdownMenuItem(
                              value: level,
                              child: Text(level),
                            ),
                          )
                          .toList(),
                  onChanged: (val) {
                    setState(() {
                      selectedLevel = val!;
                    });
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.purple,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.add, color: Colors.white),
                  onPressed: () {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: sessions.length,
              itemBuilder: (context, index) {
                final session = sessions[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.purple,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    session['language'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                    ),
                                  ),
                                  Text(
                                    session['level'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  session['participants'],
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
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            ...session['tags'].map<Widget>(
                              (tag) => Container(
                                margin: const EdgeInsets.only(right: 8),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  tag,
                                  style: const TextStyle(
                                    color: Colors.purple,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                            const Spacer(),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple.shade700,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 8,
                                ),
                              ),
                              onPressed: () {},
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
