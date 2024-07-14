import 'package:exif_toolkit/authentication/login_page.dart';
import 'package:exif_toolkit/authentication/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FlutterNativeSplash.remove();
  runApp(const EXIFDataManipulatorApp());
}

class EXIFDataManipulatorApp extends StatelessWidget {
  const EXIFDataManipulatorApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.grey[800]!, // Dark grey as the base color
          brightness: Brightness.dark, // Dark mode for a tech-focused feel
        ),
        textTheme: GoogleFonts.robotoMonoTextTheme(
          TextTheme(
            headlineMedium: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white, // White for headings for contrast
            ),
            bodyMedium: TextStyle(
              fontSize: 16,
              color: Colors.grey[300], // Light grey for body text
            ),
            labelLarge: const TextStyle(
              // Style for button labels
              color: Colors.white,
            ),
          ),
        ),
        scaffoldBackgroundColor: Colors.grey[900],
        // Dark background
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[800], // Slightly lighter app bar
          elevation: 0, // Remove shadow for a modern look
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[600], // Blue buttons for interaction
            foregroundColor: Colors.white,
          ),
        ),
        pageTransitionsTheme: PageTransitionsTheme(
          builders: Map<TargetPlatform, PageTransitionsBuilder>.fromIterable(
            TargetPlatform.values,
            value: (dynamic _) => const CupertinoPageTransitionsBuilder(),
          ),
        ),
      ),
      home: const LoginPage(),
      routes: {
        '/signup_page': (context) => const SignupPage(),
        '/login_page': (context) => const LoginPage()
      }, //Page Routes
    );
  }
}
