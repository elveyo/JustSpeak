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
  int totalPages = 10;

  List<Language>? languages;
  List<Level>? levels;

  List<User>? users = [];
  dynamic filter = {};

  @override
  void initState() {
    super.initState();
    fetchUsers();
    loadLanguagesAndLevels();
  }

  void fetchUsers() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    var usersResponse = await userProvider.get();

    setState(() {
      users = usersResponse.items;
      totalPages = usersResponse.totalCount!; // ovo backend treba vratiti
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
      setState(() {
        languages = _languages.items;
        levels = _levels.items;
      });
    } catch (e) {
      // Optionally handle error, e.g. show a snackbar or log
    }
  }

  void changePage(int page) {
    if (page > 0 && page <= totalPages) {
      setState(() {
        currentPage = page;
      });
      fetchUsers();
    }
  }

  @override
  Widget build(BuildContext context) {
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
          child: Column(
            children: [
              // Filter i search bar (dummy UI)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        DropdownButton<String>(
                          items: languages!
                              .map(
                                (lang) => DropdownMenuItem(
                                  value: lang.name,
                                  child: Text(lang.name),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              filter['languageId'] = value;
                            });
                            fetchUsers();
                          },
                        ),
                        const SizedBox(width: 40),
                        DropdownButton<String>(
                          items: levels!
                              .map(
                                (e) => DropdownMenuItem<String>(
                                  value: e.name,
                                  child: Text(e.name),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              filter['levelId'] = value;
                            });
                            fetchUsers();
                          },
                        ),
                        const SizedBox(width: 40),
                        DropdownButton<String>(
                          value: "Tutor",
                          items: ["Tutor", "Student"]
                              .map(
                                (e) =>
                                    DropdownMenuItem(value: e, child: Text(e)),
                              )
                              .toList(),
                          onChanged: (_) {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 40),
                  SizedBox(
                    width: 250,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search",
                        suffixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Tabela korisnika
              Expanded(
                child: SingleChildScrollView(
                  child: DataTable(
                    headingRowColor: MaterialStateProperty.all(
                      Colors.purple.shade100,
                    ),
                    columns: const [
                      DataColumn(label: Text("NAME")),
                      DataColumn(label: Text("E-MAIL")),
                      DataColumn(label: Text("ROLE")),
                    ],
                    rows: users!.map((u) {
                      return DataRow(
                        cells: [
                          DataCell(Text(u.firstName)),
                          DataCell(Text(u.email)),
                          DataCell(Text(u.role)),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Paginacija
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: currentPage > 1
                        ? () => changePage(currentPage - 1)
                        : null,
                    icon: const Icon(Icons.chevron_left),
                  ),
                  Text("Page $currentPage of $totalPages"),
                  IconButton(
                    onPressed: currentPage < totalPages
                        ? () => changePage(currentPage + 1)
                        : null,
                    icon: const Icon(Icons.chevron_right),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
