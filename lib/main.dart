import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tawazon/theme/app_theme.dart';
import 'package:tawazon/views/splash_screen.dart';
import 'package:tawazon/views/language_screen.dart';
import 'package:tawazon/views/login_screen.dart';
import 'package:tawazon/views/main_navigation_shell.dart';
import 'package:tawazon/views/settings_screen.dart';
import 'package:tawazon/views/risk_assessment_screen.dart';
import 'package:tawazon/views/journal_screen.dart';
import 'package:tawazon/views/cbt_learning_screen.dart';
import 'package:tawazon/views/coping_tools_screen.dart';
import 'package:tawazon/views/progress_screen.dart';
import 'package:tawazon/views/ai_patterns_screen.dart';
import 'package:tawazon/views/professional_help_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDheBDDkrcpSlMqNDqHCfIrbYvW1jj7lHA",
      authDomain: "tawazon-95f97.firebaseapp.com",
      projectId: "tawazon-95f97",
      storageBucket: "tawazon-95f97.firebasestorage.app",
      messagingSenderId: "1079474194094",
      appId: "1:1079474194094:web:2d8dab10976e5862468f3f",
    ),
  );
  
  try {
    await FirebaseAuth.instance.signInAnonymously();
  } catch (e) {
    // Auth failure is non-fatal — the app can still start; Firestore writes
    // will be rejected until the user is authenticated on next launch.
    debugPrint('Tawazon: Anonymous sign-in failed: $e');
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tawazon',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/language': (context) => const LanguageScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const MainNavigationShell(),
        '/settings': (context) => const SettingsScreen(),
        '/risk_assessment': (context) => const RiskAssessmentScreen(),
        '/journal': (context) => const JournalScreen(),
        '/cbt_learning': (context) => const CbtLearningScreen(),
        '/coping_tools': (context) => const CopingToolsScreen(),
        '/progress': (context) => const ProgressScreen(),
        '/ai_patterns': (context) => const AiPatternsScreen(),
        '/professional_help': (context) => const ProfessionalHelpScreen(),
      },
    );
  }
}
