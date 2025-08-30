import 'package:flutter/material.dart';
import 'package:frontend/screens/feed_screen.dart';
import 'package:frontend/screens/session_screen.dart';
import 'package:frontend/screens/student_sessions.dart';
import 'package:frontend/screens/tutor_calendar_screen.dart';
import 'package:frontend/screens/tutor_profile_screen.dart';
import 'package:frontend/services/auth_service.dart';

class MasterScreen extends StatelessWidget {
  MasterScreen({super.key, required this.child, required this.title});

  final Widget child;
  final String title;

  final user = AuthService().user;

  @override
  Widget build(BuildContext context) {
    final String? role = user?.role;

    // Define label and screen for third destination based on role
    final thirdDestination =
        role == 'Tutor'
            ? {
              'label': 'Calendar',
              'screen': const TutorCalendarScreen(),
              'icon': Icons.calendar_today_outlined,
              'selectedIcon': Icons.calendar_month_rounded,
            }
            : {
              'label': 'Lessons',
              'screen': const StudentSessionsScreen(),
              'icon': Icons.menu_book_outlined,
              'selectedIcon': Icons.menu_book_rounded,
            };

    // Build destinations list
    final destinations = [
      NavigationDestination(
        icon: const Icon(Icons.home_outlined),
        selectedIcon: const Icon(Icons.home_rounded),
        label: 'Home',
      ),
      NavigationDestination(
        icon: const Icon(Icons.forum_outlined),
        selectedIcon: const Icon(Icons.forum_rounded),
        label: 'Sessions',
      ),
      NavigationDestination(
        icon: Icon(thirdDestination['icon'] as IconData),
        selectedIcon: Icon(thirdDestination['selectedIcon'] as IconData),
        label: thirdDestination['label'] as String,
      ),
      NavigationDestination(
        icon: const Icon(Icons.person_outline),
        selectedIcon: const Icon(Icons.person_rounded),
        label: 'Profile',
      ),
    ];

    // Helper to get selected index
    int selectedIndex = destinations.indexWhere((d) => d.label == title);
    if (selectedIndex == -1) selectedIndex = 0;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.purple,
        title: Text(
          title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: child,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          if (index == selectedIndex) return;

          Widget? targetPage;
          switch (index) {
            case 0:
              targetPage = const FeedScreen();
              break;
            case 1:
              targetPage = const SessionsScreen();
              break;
            case 2:
              targetPage = thirdDestination['screen'] as Widget;
              break;
            case 3:
              targetPage = TutorProfileScreen(id: user!.id);
              break;
          }

          if (targetPage != null) {
            Navigator.pushReplacement(context, _fadeTo(targetPage));
          }
        },
        destinations: destinations,
        elevation: 8,
        indicatorColor: Colors.purple.withOpacity(0.1),
        surfaceTintColor: Colors.white,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        animationDuration: const Duration(milliseconds: 300),
      ),
    );
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
