import 'package:flutter/material.dart';
import 'package:frontend/screens/feed_screen.dart';
import 'package:frontend/screens/session_screen.dart';

class MasterScreen extends StatelessWidget {
  const MasterScreen({super.key, required this.child, required this.title});

  final Widget child;
  final String title;

  int _getSelectedIndex(String title) {
    switch (title) {
      case 'Home':
        return 0;
      case 'Sessions':
        return 1;
      case 'Calendar':
        return 2;
      case 'Profile':
        return 3;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.purple,
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.purple,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(padding: const EdgeInsets.all(12.0), child: child),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _getSelectedIndex(title),
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              if (title != 'Home') {
                Navigator.pushReplacement(context, _fadeTo(const FeedScreen()));
              }
              break;
            case 1:
              if (title != 'Sessions') {
                Navigator.pushReplacement(
                  context,
                  _fadeTo(const SessionsScreen()),
                );
              }
              break;
            case 2:
              if (title != 'Calendar') {
                Navigator.pushReplacement(
                  context,
                  _fadeTo(const SessionsScreen()),
                );
              }
              break;
            case 3:
              if (title != 'Profile') {
                Navigator.pushReplacement(context, _fadeTo(const FeedScreen()));
              }
              break;
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.forum_outlined),
            selectedIcon: Icon(Icons.forum_rounded),
            label: 'Sessions',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_today_outlined),
            selectedIcon: Icon(Icons.calendar_month_rounded),
            label: 'Calendar',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
        elevation: 8,
        indicatorColor: Colors.purple.withOpacity(0.1),
        surfaceTintColor: Colors.white,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        animationDuration: Duration(milliseconds: 300),
      ),
    );
    // Helper function to determine selected index based on title
  }

  static PageRouteBuilder _fadeTo(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder:
          (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
