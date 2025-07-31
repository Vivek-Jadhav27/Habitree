import 'package:flutter/material.dart';
import 'package:habitree/presentation/screens/forest_test_screen.dart';
import 'package:habitree/presentation/screens/species_gallery_screen.dart';
import 'package:habitree/providers/forest_provider.dart';
import 'package:habitree/providers/habit_provider.dart';
import 'package:habitree/providers/login_provider.dart';
import 'package:habitree/providers/signup_provider.dart';
import 'package:provider/provider.dart';

import '../presentation/screens/splash_screen.dart';
import '../presentation/screens/login_screen.dart';
import '../presentation/screens/signup_screen.dart';
import '../presentation/screens/home_screen.dart';
import '../presentation/screens/habit_wizard_screen.dart';
import '../presentation/screens/forest_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String habitWizard = '/habit-wizard';
  static const String forest = '/forest';
  static const String forestTest = '/forest-test';
  static const String gardenLibrary = '/species-gallery';

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    login: (context) => const LoginScreen(),
    signup: (context) => const SignupScreen(),
    home: (context) => const HomeScreen(),
    habitWizard: (context) => const HabitWizardScreen(),
    forest: (context) => const ForestScreen(),
    gardenLibrary: (context) => const GardenLibraryScreen(),
    forestTest: (context) => const ForestTestScreen(),
  };

  List allProviders = [
    ChangeNotifierProvider(create: (_) => ForestProvider()..loadForest()),
    ChangeNotifierProvider(create: (_) => HabitProvider()..loadHabits()),
    ChangeNotifierProvider(create: (_) => SignupProvider()),
    ChangeNotifierProvider(create: (_) => LoginProvider()),
  ];
}
