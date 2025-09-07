import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:justspeak_desktop/layouts/master_screen.dart';
import 'package:justspeak_desktop/providers/level_provider.dart';
import 'package:justspeak_desktop/providers/language_provider.dart';
import 'package:justspeak_desktop/providers/payment_provider.dart';
import 'package:justspeak_desktop/providers/user_provider.dart';
import 'package:justspeak_desktop/screens/login_screen.dart';
import 'package:justspeak_desktop/screens/statistics_screen.dart';
import 'package:justspeak_desktop/services/auth_service.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authService = AuthService();
  await authService.loadToken();

  try {
    Stripe.publishableKey =
        "pk_test_51RL0ZVAHXQropxlzi4AeoE2awEiSSLusn5TM44Gd0zWsAtkWTTof5ZGB82X5OtQWwFdJgXqz08as63s1b2FLqdta00h2dLDcBL";

    await Stripe.instance.applySettings();
    print("Stripe initialized successfully");
  } catch (e) {
    print("Stripe initialization failed: $e");
    // Continue with app initialization even if Stripe fails
  }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<LanguageProvider>(
          create: (context) => LanguageProvider(),
        ),
        ChangeNotifierProvider<LevelProvider>(
          create: (context) => LevelProvider(),
        ),
        ChangeNotifierProvider<UserProvider>(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider<PaymentProvider>(
          create: (context) => PaymentProvider(),
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
      home: isUserLogged ? MasterScreen() : LoginScreen(),
    );
  }
}
