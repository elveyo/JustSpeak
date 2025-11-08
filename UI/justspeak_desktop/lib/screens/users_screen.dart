import 'package:flutter/material.dart';
import 'package:justspeak_desktop/models/language.dart';
import 'package:justspeak_desktop/models/level.dart';
import 'package:justspeak_desktop/models/user.dart';
import 'package:justspeak_desktop/providers/language_provider.dart';
import 'package:justspeak_desktop/providers/level_provider.dart';
import 'package:justspeak_desktop/providers/user_provider.dart';
import 'package:provider/provider.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersScreen> {
  int currentPage = 1;
  int itemsPerPage = 10;
  int totalPages = 1;
  int totalUserCount = 0;
  List<Language>? languages;
  List<Level>? levels;

  List<User>? users = [];
  dynamic filter = {};

  // Trackers for selected dropdown values
  String? selectedLanguageName = "All";
  String? selectedLevelName = "All";
  String? selectedRole = "All";

  // Controller for search bar
  final TextEditingController _searchController = TextEditingController();

  // Dropdown "All" constants
  static const String allLanguagesOption = "All";
  static const String allLevelsOption = "All";
  static const String allRolesOption = "All";
  static const List<String> roleOptions = [allRolesOption, "Tutor", "Student"];

  @override
  void initState() {
    super.initState();
    fetchUsers();
    loadLanguagesAndLevels();
  }

  void fetchUsers() async {
    // For BE -1 for 0-based
    filter['page'] = currentPage - 1;
    filter['pageSize'] = itemsPerPage;
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    var usersResponse = await userProvider.get(filter: filter);
    print(usersResponse.totalCount);

    setState(() {
      users = usersResponse.items;
      totalUserCount = usersResponse.totalCount ?? users?.length ?? 0;
      totalPages = ((usersResponse.totalCount ?? 0) / itemsPerPage).ceil();
      if (totalPages == 0) {
        totalPages = 1;
      }
    });
  }

  Future<void> loadLanguagesAndLevels() async {
    try {
      final languageProvider = Provider.of<LanguageProvider>(
        context,
        listen: false,
      );
      final levelProvider = Provider.of<LevelProvider>(context, listen: false);
      final _languages = await languageProvider.get();
      final _levels = await levelProvider.get();

      // Insert "All" option at the beginning only for display, not to DB
      setState(() {
        languages = _languages.items;
        levels = _levels.items;

        // Set selectedLanguage/Level to "All" if not set, else preserve selection
        if (selectedLanguageName == null) {
          selectedLanguageName = allLanguagesOption;
          filter.remove('languageId');
        } else if (selectedLanguageName != allLanguagesOption) {
          final savedLang = languages?.firstWhere(
            (lang) => lang.name == selectedLanguageName,
            orElse: () => languages!.first,
          );
          filter['languageId'] = savedLang?.id;
        } else if (selectedLanguageName == allLanguagesOption) {
          filter.remove('languageId');
        }

        if (selectedLevelName == null) {
          selectedLevelName = allLevelsOption;
          filter.remove('levelId');
        } else if (selectedLevelName != allLevelsOption) {
          final savedLevel = levels?.firstWhere(
            (level) => level.name == selectedLevelName,
            orElse: () => levels!.first,
          );
          filter['levelId'] = savedLevel?.id;
        } else if (selectedLevelName == allLevelsOption) {
          filter.remove('levelId');
        }

        // Role
        if (selectedRole == null) {
          selectedRole = allRolesOption;
          filter.remove('role');
        } else if (selectedRole == allRolesOption) {
          filter.remove('role');
        } else {
          filter['role'] = selectedRole;
        }
      });
      fetchUsers(); // fetch users again with loaded filter data
    } catch (e) {
      // Optionally handle error, e.g. show a snackbar or log
    }
  }

  void changePage(int page) {
    // argument page in BE indexing (starts from 0)
    // UI should show 1-based, so page param is 0-based, currentPage = page+1
    if (page >= 0 && page < totalPages) {
      setState(() {
        currentPage = page + 1;
      });
      fetchUsers();
    }
  }

  void _onSearch([String? submitted]) {
    setState(() {
      filter['FTS'] = _searchController.text.trim().isNotEmpty
          ? _searchController.text.trim()
          : null;
      // Reset to first page on new search (UI page 1, BE page 0)
      currentPage = 1;
    });
    fetchUsers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<DropdownMenuItem<String>> _buildLanguageDropdownItems() {
    final List<DropdownMenuItem<String>> items = [
      const DropdownMenuItem(
        value: allLanguagesOption,
        child: Text("All Languages"),
      ),
    ];
    if (languages != null) {
      items.addAll(
        languages!.map(
          (lang) => DropdownMenuItem(value: lang.name, child: Text(lang.name)),
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<String>> _buildLevelDropdownItems() {
    final List<DropdownMenuItem<String>> items = [
      const DropdownMenuItem(value: allLevelsOption, child: Text("All Levels")),
    ];
    if (levels != null) {
      items.addAll(
        levels!.map(
          (e) => DropdownMenuItem<String>(value: e.name, child: Text(e.name)),
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<String>> _buildRoleDropdownItems() {
    return [
      const DropdownMenuItem(value: allRolesOption, child: Text("All Roles")),
      const DropdownMenuItem(value: "Tutor", child: Text("Tutor")),
      const DropdownMenuItem(value: "Student", child: Text("Student")),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final bool noUsers = users == null || users!.isEmpty;

    final Size screenSize = MediaQuery.of(context).size;
    // 90% of screen for container; then inside, table area is (almost) 90% of the content
    final double containerWidth = screenSize.width * 0.9;
    final double containerHeight = screenSize.height * 0.9;

    // You can tune these further to fit the filter+pag+table
    final double filterHeight = 64; // Approximate, can be adjusted
    final double spacing = 20 + 20; // two SizedBoxes
    final double paginationHeight = 56; // Approximate row for pagination
    final double tableHeight =
        containerHeight - (filterHeight + spacing + paginationHeight);

    return Scaffold(
      backgroundColor: Colors.purple.shade600,
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          width: containerWidth,
          height: containerHeight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Filter i search bar
              SizedBox(
                height: filterHeight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          DropdownButton<String>(
                            value: selectedLanguageName ?? allLanguagesOption,
                            items: _buildLanguageDropdownItems(),
                            onChanged: (value) {
                              setState(() {
                                selectedLanguageName = value;
                                if (value == allLanguagesOption) {
                                  filter.remove('languageId');
                                } else {
                                  final selectedLang = languages?.firstWhere(
                                    (lang) => lang.name == value,
                                    orElse: () => languages!.first,
                                  );
                                  filter['languageId'] = selectedLang?.id;
                                }
                              });
                              // Keep currentPage but send correct BE page
                              fetchUsers();
                            },
                          ),
                          const SizedBox(width: 40),
                          DropdownButton<String>(
                            value: selectedLevelName ?? allLevelsOption,
                            items: _buildLevelDropdownItems(),
                            onChanged: (value) {
                              setState(() {
                                selectedLevelName = value;
                                if (value == allLevelsOption) {
                                  filter.remove('levelId');
                                } else {
                                  final selectedLvl = levels?.firstWhere(
                                    (level) => level.name == value,
                                    orElse: () => levels!.first,
                                  );
                                  filter['levelId'] = selectedLvl?.id;
                                }
                              });
                              fetchUsers();
                            },
                          ),
                          const SizedBox(width: 40),
                          DropdownButton<String>(
                            value: selectedRole ?? allRolesOption,
                            items: _buildRoleDropdownItems(),
                            onChanged: (value) {
                              setState(() {
                                selectedRole = value;
                                if (value == allRolesOption) {
                                  filter.remove('role');
                                } else {
                                  filter['role'] = value;
                                }
                              });
                              fetchUsers();
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 40),
                    SizedBox(
                      width: 250,
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: "Search",
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () => _onSearch(),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onSubmitted: _onSearch,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Table or no users found message (90% width, height: tableHeight with scroll)
              Expanded(
                child: Center(
                  child: SizedBox(
                    width: containerWidth * 0.9,
                    height: tableHeight,
                    child: noUsers
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(40.0),
                              child: Text(
                                "No users found",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Show the total user count above the table
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 8.0,
                                  bottom: 8.0,
                                ),
                                child: Text(
                                  "Total users: $totalUserCount",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              // DataTable with scroll
                              Expanded(
                                child: Scrollbar(
                                  thumbVisibility: true,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: ConstrainedBox(
                                        constraints: BoxConstraints(
                                          minWidth: containerWidth * 0.9,
                                          // can set maxHeight/table row height if desired
                                        ),
                                        child: DataTable(
                                          headingRowColor:
                                              WidgetStateProperty.all<Color>(
                                                Colors.purple.shade100,
                                              ),
                                          columns: const [
                                            DataColumn(label: Text("ID")),
                                            DataColumn(label: Text("NAME")),
                                            DataColumn(label: Text("E-MAIL")),
                                            DataColumn(label: Text("ROLE")),
                                          ],
                                          rows: (users ?? [])
                                              .map(
                                                (u) => DataRow(
                                                  cells: [
                                                    DataCell(
                                                      Text(u.id.toString()),
                                                    ),
                                                    DataCell(Text(u.firstName)),
                                                    DataCell(Text(u.email)),
                                                    DataCell(Text(u.role)),
                                                  ],
                                                ),
                                              )
                                              .toList(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Pagination row
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: currentPage > 1
                                        ? () => changePage(currentPage - 2)
                                        : null,
                                    icon: const Icon(Icons.chevron_left),
                                  ),
                                  Text("Page $currentPage of $totalPages"),
                                  IconButton(
                                    onPressed: currentPage < totalPages
                                        ? () => changePage(currentPage)
                                        : null,
                                    icon: const Icon(Icons.chevron_right),
                                  ),
                                ],
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
