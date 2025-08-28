import 'package:flutter/material.dart';
import 'package:frontend/providers/language_level_provider.dart';
import 'package:frontend/providers/language_provider.dart';
import 'package:frontend/providers/schedule_provider.dart';
import 'package:frontend/providers/session_provider.dart';
import 'package:frontend/screens/session_screen.dart';
import 'package:frontend/providers/post_provider.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authService = AuthService();
  await authService.loadToken();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<PostProvider>(
          create: (context) => PostProvider(),
        ),
        ChangeNotifierProvider<SessionProvider>(
          create: (context) => SessionProvider(),
        ),
        ChangeNotifierProvider<LanguageProvider>(
          create: (context) => LanguageProvider(),
        ),
        ChangeNotifierProvider<LanguageLevelProvider>(
          create: (context) => LanguageLevelProvider(),
        ),
        ChangeNotifierProvider<ScheduleProvider>(
          create: (context) => ScheduleProvider(),
        ),
      ],
      child: MyApp(isUserLogged: authService.isLoggedIn),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isUserLogged;

  const MyApp({super.key, required this.isUserLogged});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.white,
          primary: Color.fromARGB(255, 152, 13, 216),
          secondary: Color(0xFF6A1B9A),
        ),
      ),
      home: isUserLogged ? SessionsScreen() : LoginScreen(),
    );
  }
}
