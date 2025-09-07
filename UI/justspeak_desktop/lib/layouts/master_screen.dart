import 'package:flutter/material.dart';
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
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                      'https://your-image-url.com/avatar.png',
                    ), // ili AssetImage
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
