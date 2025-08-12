import 'package:flutter/material.dart';
import 'package:frontend/providers/language_level_provider.dart';
import 'package:frontend/providers/language_provider.dart';
import 'package:frontend/providers/session_provider.dart';
import 'package:frontend/screens/feed_screen.dart';
import 'package:frontend/screens/session_screen.dart';
import 'package:frontend/providers/post_provider.dart';
import 'package:frontend/screens/add_post_screen.dart';
import 'package:frontend/screens/video_call_screen.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';
import 'screens/registration_screen.dart';

void main() {
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
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
          primary: Colors.white,
        ),
      ),
      home: SessionsScreen(),
    );
  }
}
