import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:justspeak_desktop/providers/language_provider.dart';
import 'package:justspeak_desktop/providers/level_provider.dart';
import 'package:justspeak_desktop/providers/tag_provider.dart';
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
  List<Language> _languages = [];
  List<Level> _levels = [];
  List<Tag> _tags = [];

  Color _tagColor = Colors.green;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchLanguagesLevelsTags(context);
    });
  }

  Future<void> fetchLanguagesLevelsTags(BuildContext context) async {
    try {
      final languageProvider = Provider.of<LanguageProvider>(
        context,
        listen: false,
      );
      final levelProvider = Provider.of<LevelProvider>(context, listen: false);
      final tagProvider = Provider.of<TagProvider>(context, listen: false);

      final languagesResponse = await languageProvider.get();
      final levelsResponse = await levelProvider.get();
      final tagsResponse = await tagProvider.get();

      setState(() {
        _languages = languagesResponse.items ?? [];
        _levels = levelsResponse.items ?? [];
        _tags = tagsResponse.items ?? [];
      });
    } catch (e) {
      print("Failed to fetch languages, levels, or tags: $e");
    }
  }

  void _showAddLanguageDialog() {
    showDialog(
      context: context,
      builder: (_) {
        final TextEditingController tempController = TextEditingController(
          text: "",
        );
        return AlertDialog(
          title: const Text("Add Language"),
          content: TextField(
            controller: tempController,
            decoration: const InputDecoration(labelText: "New language"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (tempController.text.isNotEmpty) {
                  final lang = Language(
                    id: 0, // Dummy for creation (real id comes from backend)
                    name: tempController.text,
                  );
                  try {
                    final languageProvider = Provider.of<LanguageProvider>(
                      context,
                      listen: false,
                    );
                    final created = await languageProvider.insert(lang);
                    setState(() {
                      _languages.add(created ?? lang);
                    });
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Failed to add language: $e")),
                    );
                  }
                }
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void _showAddLevelDialog() {
    showDialog(
      context: context,
      builder: (_) {
        final nameCtrl = TextEditingController();
        final descCtrl = TextEditingController();
        final orderCtrl = TextEditingController();
        final maxPointsCtrl = TextEditingController();
        return AlertDialog(
          title: const Text("Add Level"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: "Name"),
                ),
                TextField(
                  controller: descCtrl,
                  decoration: const InputDecoration(labelText: "Description"),
                ),
                TextField(
                  controller: orderCtrl,
                  decoration: const InputDecoration(labelText: "Order"),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: maxPointsCtrl,
                  decoration: const InputDecoration(labelText: "Max Points"),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameCtrl.text.isNotEmpty) {
                  final newLevel = Level(
                    id: 0, // For creation - real id comes from backend
                    name: nameCtrl.text,
                    description: descCtrl.text,
                    maxPoints: int.tryParse(maxPointsCtrl.text) ?? 0,
                    order: int.tryParse(orderCtrl.text) ?? 0,
                  );
                  try {
                    final levelProvider = Provider.of<LevelProvider>(
                      context,
                      listen: false,
                    );
                    final created = await levelProvider.insert(newLevel);
                    setState(() {
                      _levels.add(created ?? newLevel);
                    });
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Failed to add level: $e")),
                    );
                  }
                }
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void _showAddTagDialog() {
    Color pickedColor = _tagColor;
    showDialog(
      context: context,
      builder: (_) {
        final nameCtrl = TextEditingController();
        return AlertDialog(
          title: const Text("Add Tag"),
          content: StatefulBuilder(
            builder: (context, setStateSB) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: "Name"),
                ),
                const SizedBox(height: 10),
                BlockPicker(
                  pickerColor: pickedColor,
                  onColorChanged: (c) {
                    setStateSB(() => pickedColor = c);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameCtrl.text.isNotEmpty) {
                  final Tag newTag = Tag(
                    id: 0,
                    name: nameCtrl.text,
                    color:
                        '#${pickedColor.value.toRadixString(16).padLeft(8, '0')}',
                  );
                  try {
                    final tagProvider = Provider.of<TagProvider>(
                      context,
                      listen: false,
                    );
                    final created = await tagProvider.insert(newTag);
                    setState(() {
                      _tags.add(created ?? newTag);
                    });
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Failed to add tag: $e")),
                    );
                  }
                }
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void _showEditTagDialog(Tag tag) {
    final nameCtrl = TextEditingController(text: tag.name);
    Color pickedColor = _colorFromTagColor(tag.color);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Update Tag"),
        content: StatefulBuilder(
          builder: (context, setStateSB) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              const SizedBox(height: 10),
              BlockPicker(
                pickerColor: pickedColor,
                onColorChanged: (c) => setStateSB(() => pickedColor = c),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              final updatedTag = Tag(
                id: tag.id,
                name: nameCtrl.text,
                color:
                    '#${pickedColor.value.toRadixString(16).padLeft(8, '0')}',
              );
              try {
                final tagProvider = Provider.of<TagProvider>(
                  context,
                  listen: false,
                );
                final result = await tagProvider.update(tag.id, updatedTag);
                setState(() {
                  tag.name = result?.name ?? updatedTag.name;
                  tag.color = result?.color ?? updatedTag.color;
                });
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Failed to update tag: $e")),
                );
              }
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  /// Helper function to parse a hex string (like "#AARRGGBB" or "AARRGGBB" or "#RRGGBB"/"RRGGBB") to a Color object.
  Color _colorFromTagColor(String hexColor) {
    if (hexColor.startsWith('#')) {
      hexColor = hexColor.substring(1);
    }
    if (hexColor.length == 6) {
      // If RRGGBB, default alpha to FF.
      hexColor = 'FF$hexColor';
    } else if (hexColor.length == 8) {
      // already AARRGGBB
    } else if (hexColor.length == 3) {
      // e.g. FFF
      hexColor =
          'FF' +
          hexColor
              .split('')
              .map((c) => c * 2)
              .join(); // expand short hex like FFF to FFFFFF
    }
    return Color(int.parse(hexColor, radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Languages
            _buildSection(
              title: "Languages",
              action: ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text("Add Language"),
                onPressed: _showAddLanguageDialog,
              ),
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
                                onPressed: () async {
                                  final updatedName = controller.text;
                                  if (updatedName.trim().isEmpty) {
                                    Navigator.pop(context);
                                    return;
                                  }
                                  final updatedLang = Language(
                                    id: lang.id,
                                    name: updatedName,
                                  );
                                  try {
                                    final languageProvider =
                                        Provider.of<LanguageProvider>(
                                          context,
                                          listen: false,
                                        );
                                    final result = await languageProvider
                                        .update(lang.id, updatedLang);
                                    setState(() {
                                      lang.name = result?.name ?? updatedName;
                                    });
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "Failed to update language: $e",
                                        ),
                                      ),
                                    );
                                  }
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
              ],
            ),

            const SizedBox(height: 20),

            /// Levels
            _buildSection(
              title: "Levels",
              action: ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text("Add Level"),
                onPressed: _showAddLevelDialog,
              ),
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
                                onPressed: () async {
                                  final updatedLevel = Level(
                                    id: lvl.id,
                                    name: nameCtrl.text,
                                    description: descCtrl.text,
                                    order: int.tryParse(orderCtrl.text) ?? 0,
                                    maxPoints:
                                        int.tryParse(maxPointsCtrl.text) ?? 0,
                                  );
                                  try {
                                    final levelProvider =
                                        Provider.of<LevelProvider>(
                                          context,
                                          listen: false,
                                        );
                                    final result = await levelProvider.update(
                                      lvl.id,
                                      updatedLevel,
                                    );
                                    setState(() {
                                      lvl.name =
                                          result?.name ?? updatedLevel.name;
                                      lvl.description =
                                          result?.description ??
                                          updatedLevel.description;
                                      lvl.order =
                                          result?.order ?? updatedLevel.order;
                                      lvl.maxPoints =
                                          result?.maxPoints ??
                                          updatedLevel.maxPoints;
                                    });
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "Failed to update level: $e",
                                        ),
                                      ),
                                    );
                                  }
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
              ],
            ),

            const SizedBox(height: 20),

            /// Tags
            _buildSection(
              title: "Tags",
              action: ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text("Add Tag"),
                onPressed: _showAddTagDialog,
              ),
              children: [
                ..._tags.map(
                  (tag) => ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _colorFromTagColor(tag.color),
                    ),
                    title: Text(tag.name),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _showEditTagDialog(tag);
                      },
                    ),
                  ),
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
    Widget? action,
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
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (action != null) action,
              ],
            ),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }
}
