import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:frontend/providers/certificate_provider.dart';
import 'package:frontend/providers/language_level_provider.dart';
import 'package:frontend/providers/language_provider.dart';
import 'package:frontend/providers/payment_provider.dart';
import 'package:frontend/providers/schedule_provider.dart';
import 'package:frontend/providers/session_provider.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/screens/feed_screen.dart';
import 'package:frontend/providers/post_provider.dart';

import 'package:frontend/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authService = AuthService();
  await authService.loadToken();

  try {
    Stripe.publishableKey =
        "pk_test_51RL0ZVAHXQropxlzi4AeoE2awEiSSLusn5TM44Gd0zWsAtkWTTof5ZGB82X5OtQWwFdJgXqz08as63s1b2FLqdta00h2dLDcBL";

    await Stripe.instance.applySettings();
  } catch (e) {}
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
        ChangeNotifierProvider<PaymentProvider>(
          create: (context) => PaymentProvider(),
        ),
        ChangeNotifierProvider<UserProvider>(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider<CertificateProvider>(
          create: (context) => CertificateProvider(),
        ),
      ],
      child: MyApp(isUserAuthenticated: authService.isAuthenticated),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isUserAuthenticated;

  const MyApp({super.key, required this.isUserAuthenticated});

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
      home: isUserAuthenticated ? FeedScreen() : LoginScreen(),
    );
  }
}
