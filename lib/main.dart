import 'package:exif_toolkit/pages/home_page.dart';
import 'package:exif_toolkit/pages/login_page.dart';
import 'package:exif_toolkit/pages/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await Permission.manageExternalStorage.request();

  runApp(const EXIFDataManipulatorApp());
}

class EXIFDataManipulatorApp extends StatelessWidget {
  const EXIFDataManipulatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: const [Locale('en')],
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1877F2), // Facebook blue as the base color
          brightness: Brightness.light, // Facebook uses a light theme
        ),
        textTheme: GoogleFonts.robotoTextTheme(
          // Using Roboto, a common font for social media apps
          const TextTheme(
            headlineMedium: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black, // Black for titles and headings
            ),
            bodyMedium: TextStyle(
              fontSize: 16,
              color: Colors.black, // Black for body text
            ),
            labelLarge: TextStyle(
              // Style for button labels
              color: Colors.white,
            ),
          ),
        ),
        scaffoldBackgroundColor: Colors.white,
        // White background
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1877F2), // Facebook blue app bar
          elevation: 1, // Subtle elevation
          titleTextStyle: TextStyle(
            fontFamily: 'Roboto',
            color: Colors.white, // White title text
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.white), // White icons
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1877F2), // Facebook blue buttons
            foregroundColor: Colors.white, // White text on buttons
          ),
        ),
        // You can keep the CupertinoPageTransitionsBuilder if you prefer that style
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
        '/login_page': (context) => const LoginPage(),
        '/home_page': (context) => const HomePage()
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
