import 'package:flutter/material.dart';
import 'package:justspeak_desktop/screens/login_screen.dart';
import 'package:justspeak_desktop/services/auth_service.dart';
import 'package:justspeak_desktop/screens/payment_screen.dart';
import 'package:justspeak_desktop/screens/settings_screen.dart';
import 'package:justspeak_desktop/screens/statistics_screen.dart';
import 'package:justspeak_desktop/screens/users_screen.dart';

class MasterScreen extends StatefulWidget {
  @override
  State<MasterScreen> createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Validate session
    if (AuthService().user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await AuthService().logout();
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
      });
    }
  }

  // Lista screenova za glavni content
  final List<Widget> _screens = [
    Center(child: StatisticsScreen()),
    Center(child: UsersScreen()),
    Center(child: PaymentsScreen()),
    Center(child: SettingsScreen()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 80,
            color: Colors.purple,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.bar_chart, color: Colors.white),
                      onPressed: () => setState(() => _selectedIndex = 0),
                    ),
                    IconButton(
                      icon: Icon(Icons.person, color: Colors.white),
                      onPressed: () => setState(() => _selectedIndex = 1),
                    ),
                    IconButton(
                      icon: Icon(Icons.attach_money, color: Colors.white),
                      onPressed: () => setState(() => _selectedIndex = 2),
                    ),
                    IconButton(
                      icon: Icon(Icons.settings, color: Colors.white),
                      onPressed: () => setState(() => _selectedIndex = 3),
                    ),
                  ],
                ),

                // Logout / profile
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: PopupMenuButton<String>(
                    offset: const Offset(60, -60),
                    onSelected: (value) async {
                      if (value == 'logout') {
                        await AuthService().logout();
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      }
                    },
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        enabled: false,
                        child: Text(
                          AuthService().user?.fullName ?? "Admin",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const PopupMenuDivider(),
                      const PopupMenuItem<String>(
                        value: 'logout',
                        child: Row(
                          children: [
                            Icon(Icons.logout, color: Colors.black54),
                            SizedBox(width: 8),
                            Text('Logout'),
                          ],
                        ),
                      ),
                    ],
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.purple.shade200,
                      backgroundImage: AuthService().user?.imageUrl != null &&
                              AuthService().user!.imageUrl.isNotEmpty
                          ? NetworkImage(AuthService().user!.imageUrl)
                          : null,
                      child: (AuthService().user?.imageUrl == null ||
                              AuthService().user!.imageUrl.isEmpty)
                          ? const Icon(Icons.person, color: Colors.white)
                          : null,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Glavni content
          Expanded(
            child: Container(
              color: Colors.white,
              child: _screens[_selectedIndex],
            ),
          ),
        ],
      ),
    );
  }
}
