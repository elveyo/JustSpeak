import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:frontend/models/language.dart';
import 'package:frontend/models/level.dart';
import 'package:frontend/models/search_result.dart';
import 'package:frontend/models/session.dart';
import 'package:frontend/models/tag.dart';
import 'package:frontend/providers/language_level_provider.dart';
import 'package:frontend/providers/language_provider.dart';
import 'package:frontend/providers/session_provider.dart';
import 'package:frontend/screens/session_screen.dart';
import 'package:frontend/screens/video_call_screen.dart';
import 'package:provider/provider.dart';

class CreateSessionScreen extends StatefulWidget {
  List<Language>? languages;
  List<Level>? levels;

  CreateSessionScreen({
    super.key,
    required this.languages,
    required this.levels,
  });

  @override
  State<CreateSessionScreen> createState() => _CreateSessionScreenState();
}

class _CreateSessionScreenState extends State<CreateSessionScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  int? selectedLanguage;
  int? selectedLevel;
  int selectedPeople = 2;

  List<Tag>? tags;

  @override
  void initState() {
    super.initState();
    _getTags();
  }

  /// Generates a unique channel name for the session.
  /// Combines language, level, and a timestamp for uniqueness.
  String generateChannelName(int? languageId, int? levelId) {
    final now = DateTime.now().millisecondsSinceEpoch;
    return 'channel_${languageId ?? "lang"}_${levelId ?? "lvl"}_$now';
  }

  Future<void> _getTags() async {
    try {
      final sessionProvider = Provider.of<SessionProvider>(
        context,
        listen: false,
      );
      final fetchedTags = await sessionProvider.getTags();
      setState(() {
        tags = fetchedTags.items;
      });
    } catch (e) {
      print('Failed to fetch tags: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to fetch tags')));
    }
  }

  Future<void> createSession() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final values = _formKey.currentState!.value;

      final postData = {
        "languageId": values["language"],
        "levelId": values['level'],
        "numOfUsers": values["people"],
        "duration": values["duration"],
        "channelName": generateChannelName(values['language'], values["level"]),
        "tags":
            (values["tags"])
                .where((tag) => tag != null)
                .map((tag) => tag.id)
                .toList(),
      };

      try {
        final sessionProvider = Provider.of<SessionProvider>(
          context,
          listen: false,
        );
        Session session = await sessionProvider.insert(postData);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Session created successfully')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (_) => VideoCallScreen(
                  channelName: session.channelName!,
                  token: session.token!,
                  remainingSeconds: session.duration * 60,
                ),
          ),
        );
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6FF), // light background
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    48, // 48 = 24(top) + 24(bottom) padding
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'CREATE SESSION',

                          style: TextStyle(
                            color: Color(0xFFB000FF),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(
                            Icons.close,
                            color: Color(0xFFB000FF),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Language
                    FormBuilder(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Language
                          const Text(
                            'Language',
                            style: TextStyle(
                              color: Color(0xFFB000FF),
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          FormBuilderDropdown<int>(
                            name: 'language',
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                            items:
                                (widget.languages ?? [])
                                    .map(
                                      (lang) => DropdownMenuItem(
                                        value: lang.id,
                                        child: Text(lang.name),
                                      ),
                                    )
                                    .toList(),
                            onChanged:
                                (value) =>
                                    setState(() => selectedLanguage = value!),
                            initialValue:
                                (widget.languages != null &&
                                        widget.languages!.isNotEmpty)
                                    ? widget.languages!.first.id
                                    : null,
                          ),

                          const SizedBox(height: 20),

                          // Level
                          const Text(
                            'Level',
                            style: TextStyle(
                              color: Color(0xFFB000FF),
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          FormBuilderDropdown<int>(
                            name: 'level',
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                            items:
                                (widget.levels ?? [])
                                    .map(
                                      (level) => DropdownMenuItem(
                                        value: level.id,
                                        child: Text(level.name),
                                      ),
                                    )
                                    .toList(),
                            onChanged:
                                (value) =>
                                    setState(() => selectedLevel = value!),
                            initialValue:
                                (widget.levels != null &&
                                        widget.levels!.isNotEmpty)
                                    ? widget.levels!.first.id
                                    : null,
                          ),

                          const SizedBox(height: 20),

                          // People
                          const Text(
                            'People',
                            style: TextStyle(
                              color: Color(0xFFB000FF),
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          FormBuilderField<int>(
                            name: 'people',
                            initialValue: selectedPeople,
                            builder: (FormFieldState<int?> field) {
                              return Row(
                                children: List.generate(3, (index) {
                                  int peopleCount = index + 2;
                                  bool isSelected = field.value == peopleCount;
                                  return Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        field.didChange(peopleCount);
                                        setState(
                                          () => selectedPeople = peopleCount,
                                        );
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(
                                          right: index < 2 ? 12.0 : 0.0,
                                        ),
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color:
                                              isSelected
                                                  ? const Color(0xFFB000FF)
                                                  : Colors.transparent,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(
                                            color:
                                                isSelected
                                                    ? const Color(0xFFB000FF)
                                                    : Colors.grey.shade400,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: List.generate(
                                            peopleCount,
                                            (_) => Icon(
                                              Icons.person,
                                              size: 20,
                                              color:
                                                  isSelected
                                                      ? Colors.white
                                                      : const Color(0xFFB000FF),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              );
                            },
                          ),

                          const SizedBox(height: 20),

                          const Text(
                            'Duration',
                            style: TextStyle(
                              color: Color(0xFFB000FF),
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),

                          FormBuilderField<int>(
                            name: 'duration',
                            initialValue: 30,
                            builder: (FormFieldState<int?> field) {
                              // Three boxes for 30min, 45min, 60min, spaced to fill row
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children:
                                    [30, 45, 60].map((duration) {
                                      final isSelected =
                                          field.value == duration;
                                      return Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            field.didChange(duration);
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(
                                              right:
                                                  duration != 60 ? 12.0 : 0.0,
                                            ),
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color:
                                                  isSelected
                                                      ? const Color(0xFFB000FF)
                                                      : Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                color:
                                                    isSelected
                                                        ? const Color(
                                                          0xFFB000FF,
                                                        )
                                                        : Colors.grey.shade400,
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                '$duration min',
                                                style: TextStyle(
                                                  color:
                                                      isSelected
                                                          ? Colors.white
                                                          : const Color(
                                                            0xFFB000FF,
                                                          ),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                              );
                            },
                          ),

                          const SizedBox(height: 20),
                          // Tags
                          const Text(
                            'Tags',
                            style: TextStyle(
                              color: Color(0xFFB000FF),
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Dummy tags array
                          StatefulBuilder(
                            builder: (context, setState) {
                              // Use a Set to track selected tags
                              final selectedTags = Set<Tag>.from(
                                (_formKey.currentState?.fields['tags']?.value ??
                                    <String>[]),
                              );

                              void toggleTag(Tag tag) {
                                setState(() {
                                  if (selectedTags.contains(tag)) {
                                    selectedTags.remove(tag);
                                  } else {
                                    if (selectedTags.length < 3) {
                                      selectedTags.add(tag);
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'You can select up to 3 tags only.',
                                          ),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    }
                                  }
                                  // Update the form field value
                                  _formKey.currentState?.fields['tags']
                                      ?.didChange(selectedTags.toList());
                                });
                              }

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children:
                                        (tags ?? []).map((tag) {
                                          final isSelected = selectedTags
                                              .contains(tag);
                                          return GestureDetector(
                                            onTap: () => toggleTag(tag),
                                            child: Opacity(
                                              opacity: isSelected ? 0.5 : 1.0,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 6,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color:
                                                      isSelected
                                                          ? const Color(
                                                            0xFFB000FF,
                                                          )
                                                          : Colors.transparent,

                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                  tag.name,
                                                  style: TextStyle(
                                                    color:
                                                        isSelected
                                                            ? Colors.white
                                                            : Color(
                                                              int.parse(
                                                                tag.color
                                                                    .replaceFirst(
                                                                      '#',
                                                                      '0xFF',
                                                                    ),
                                                              ),
                                                            ),
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                  ),
                                  // Hidden field to store selected tags in the form
                                  FormBuilderField<List<Tag>>(
                                    name: 'tags',
                                    initialValue: selectedTags.toList(),
                                    builder: (field) => const SizedBox.shrink(),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                    // Create Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6A1B9A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: createSession,
                        child: const Text(
                          'CREATE',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
