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
    //Themes
    final lightTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF1877F2),
        brightness: Brightness.light,
      ),
      textTheme: GoogleFonts.robotoTextTheme(
        const TextTheme(
          headlineMedium: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          bodyMedium: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
          labelLarge: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      listTileTheme: const ListTileThemeData(textColor: Colors.black),
      scaffoldBackgroundColor: Colors.white,
      // White background
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1877F2),
        elevation: 1,
        titleTextStyle: TextStyle(
          fontFamily: 'Roboto',
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1877F2),
          foregroundColor: Colors.white,
        ),
      ),

      pageTransitionsTheme: PageTransitionsTheme(
        builders: Map<TargetPlatform, PageTransitionsBuilder>.fromIterable(
          TargetPlatform.values,
          value: (dynamic _) => const CupertinoPageTransitionsBuilder(),
        ),
      ),
    );

    final darkTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF1877F2),
        brightness: Brightness.dark,
      ),
      textTheme: GoogleFonts.robotoTextTheme(
        const TextTheme(
          headlineMedium: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black, // Switch text color to white
          ),
          bodyMedium: TextStyle(
            fontSize: 16,
            color: Colors.white, // Switch text color to white
          ),
          labelLarge: TextStyle(
            color: Colors.black, // Switch text color to white
          ),
        ),
      ),
      listTileTheme: const ListTileThemeData(textColor: Colors.white),
      scaffoldBackgroundColor: const Color(0xFF212121),
      // Dark background

      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1877F2), // Maintain app bar color
        elevation: 1,
        titleTextStyle: TextStyle(
          fontFamily: 'Roboto',
          color: Colors.black, // Switch text color to black
          fontWeight: FontWeight.bold,
        ),
        iconTheme:
            IconThemeData(color: Colors.black), // Switch icon color to black
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white, // Inverse button background color
          foregroundColor: const Color(0xFF1877F2), // Inverse button text color
        ),
      ),

      pageTransitionsTheme: PageTransitionsTheme(
        builders: Map<TargetPlatform, PageTransitionsBuilder>.fromIterable(
          TargetPlatform.values,
          value: (dynamic _) => const CupertinoPageTransitionsBuilder(),
        ),
      ),
    );

    return MaterialApp(
      supportedLocales: const [Locale('en')],
      title: 'Flutter Demo',
      theme: lightTheme,
      darkTheme: darkTheme,
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
