import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:justspeak_desktop/providers/language_provider.dart';
import 'package:justspeak_desktop/providers/level_provider.dart';
import 'package:provider/provider.dart';

import '../models/language.dart';
import '../models/level.dart';
import '../models/tag.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _AdminScreenMockState();
}

class _AdminScreenMockState extends State<SettingsScreen> {
  // Mock data
  List<Language> _languages = [
    Language(id: 1, name: "English"),
    Language(id: 2, name: "Spanish"),
  ];

  List<Level> _levels = [
    Level(
      id: 1,
      name: "Beginner",
      description: "For absolute starters",
      maxPoints: 100,
      order: 1,
    ),
    Level(
      id: 2,
      name: "Intermediate",
      description: "Some experience",
      maxPoints: 200,
      order: 2,
    ),
    Level(
      id: 3,
      name: "Advanced",
      description: "Fluent usage",
      maxPoints: 300,
      order: 3,
    ),
  ];

  List<Tag> _tags = [
    Tag(id: 1, name: "Grammar", color: Colors.red.value.toRadixString(16)),
    Tag(id: 2, name: "Speaking", color: Colors.blue.value.toRadixString(16)),
  ];

  // Controllers
  final _langController = TextEditingController();
  final _levelNameController = TextEditingController();
  final _levelDescController = TextEditingController();
  final _levelOrderController = TextEditingController();
  final _levelMaxPointsController = TextEditingController();
  final _tagNameController = TextEditingController();

  Color _tagColor = Colors.green;

  @override
  void initState() {
    super.initState();
    // Optionally, fetch languages and levels from providers if needed
    // WidgetsBinding.instance.addPostFrameCallback is used to ensure context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchLanguagesAndLevels(context);
    });
  }

  Future<void> fetchLanguagesAndLevels(BuildContext context) async {
    try {
      final languageProvider = Provider.of<LanguageProvider>(
        context,
        listen: false,
      );
      final levelProvider = Provider.of<LevelProvider>(context, listen: false);

      final languagesResponse = await languageProvider.get();
      final levelsResponse = await levelProvider.get();

      setState(() {
        _languages = languagesResponse.items ?? [];
        _levels = levelsResponse.items ?? [];
      });
    } catch (e) {
      // Handle error, e.g., show a snackbar or print error
      print("Failed to fetch languages or levels: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Panel (Mock Data)")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Languages
            _buildSection(
              title: "Languages",
              children: [
                ..._languages.map(
                  (lang) => ListTile(
                    title: Text(lang.name),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        final controller = TextEditingController(
                          text: lang.name,
                        );
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text("Update Language"),
                            content: TextField(controller: controller),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Cancel"),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    lang.name = controller.text;
                                  });
                                  Navigator.pop(context);
                                },
                                child: const Text("Save"),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _langController,
                        decoration: const InputDecoration(
                          labelText: "New language",
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        if (_langController.text.isNotEmpty) {
                          setState(() {
                            _languages.add(
                              Language(
                                id: _languages.length + 1,
                                name: _langController.text,
                              ),
                            );
                            _langController.clear();
                          });
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// Levels
            _buildSection(
              title: "Levels",
              children: [
                ..._levels.map(
                  (lvl) => ListTile(
                    title: Text(lvl.name),
                    subtitle: Text(
                      "${lvl.description} (Order: ${lvl.order}, Max Points: ${lvl.maxPoints})",
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        final nameCtrl = TextEditingController(text: lvl.name);
                        final descCtrl = TextEditingController(
                          text: lvl.description,
                        );
                        final orderCtrl = TextEditingController(
                          text: lvl.order.toString(),
                        );
                        final maxPointsCtrl = TextEditingController(
                          text: lvl.maxPoints.toString(),
                        );
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text("Update Level"),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: nameCtrl,
                                  decoration: const InputDecoration(
                                    labelText: "Name",
                                  ),
                                ),
                                TextField(
                                  controller: descCtrl,
                                  decoration: const InputDecoration(
                                    labelText: "Description",
                                  ),
                                ),
                                TextField(
                                  controller: orderCtrl,
                                  decoration: const InputDecoration(
                                    labelText: "Order",
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                                TextField(
                                  controller: maxPointsCtrl,
                                  decoration: const InputDecoration(
                                    labelText: "Max Points",
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Cancel"),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    lvl.name = nameCtrl.text;
                                    lvl.description = descCtrl.text;
                                    lvl.order =
                                        int.tryParse(orderCtrl.text) ?? 0;
                                    lvl.maxPoints =
                                        int.tryParse(maxPointsCtrl.text) ?? 0;
                                  });
                                  Navigator.pop(context);
                                },
                                child: const Text("Save"),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Column(
                  children: [
                    TextField(
                      controller: _levelNameController,
                      decoration: const InputDecoration(labelText: "Name"),
                    ),
                    TextField(
                      controller: _levelDescController,
                      decoration: const InputDecoration(
                        labelText: "Description",
                      ),
                    ),
                    TextField(
                      controller: _levelOrderController,
                      decoration: const InputDecoration(labelText: "Order"),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: _levelMaxPointsController,
                      decoration: const InputDecoration(
                        labelText: "Max Points",
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text("Add Level"),
                        onPressed: () {
                          if (_levelNameController.text.isNotEmpty) {
                            setState(() {
                              _levels.add(
                                Level(
                                  id: _levels.length + 1,
                                  name: _levelNameController.text,
                                  description: _levelDescController.text,
                                  maxPoints:
                                      int.tryParse(
                                        _levelMaxPointsController.text,
                                      ) ??
                                      0,
                                  order:
                                      int.tryParse(
                                        _levelOrderController.text,
                                      ) ??
                                      0,
                                ),
                              );
                              _levelNameController.clear();
                              _levelDescController.clear();
                              _levelOrderController.clear();
                              _levelMaxPointsController.clear();
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// Tags
            _buildSection(
              title: "Tags",
              children: [
                ..._tags.map(
                  (tag) => ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Color(int.parse(tag.color, radix: 16)),
                    ),
                    title: Text(tag.name),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        final nameCtrl = TextEditingController(text: tag.name);
                        Color pickedColor = Color(
                          int.parse(tag.color, radix: 16),
                        );
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text("Update Tag"),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: nameCtrl,
                                  decoration: const InputDecoration(
                                    labelText: "Name",
                                  ),
                                ),
                                const SizedBox(height: 10),
                                BlockPicker(
                                  pickerColor: pickedColor,
                                  onColorChanged: (c) => pickedColor = c,
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Cancel"),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    tag.name = nameCtrl.text;
                                    tag.color = pickedColor.value.toRadixString(
                                      16,
                                    );
                                  });
                                  Navigator.pop(context);
                                },
                                child: const Text("Save"),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _tagNameController,
                        decoration: const InputDecoration(labelText: "New tag"),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.color_lens),
                      onPressed: () async {
                        await showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text("Pick a color"),
                            content: BlockPicker(
                              pickerColor: _tagColor,
                              onColorChanged: (c) {
                                setState(() => _tagColor = c);
                              },
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        if (_tagNameController.text.isNotEmpty) {
                          setState(() {
                            _tags.add(
                              Tag(
                                id: _tags.length + 1,
                                name: _tagNameController.text,
                                color: _tagColor.value.toRadixString(16),
                              ),
                            );
                            _tagNameController.clear();
                          });
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }
}
