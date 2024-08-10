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
      ),
      home: const HomePage(),
      routes: {
        '/signup_page': (context) => const SignupPage(),
        '/login_page': (context) => const LoginPage(),
        '/home_page': (context) => const HomePage()
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
