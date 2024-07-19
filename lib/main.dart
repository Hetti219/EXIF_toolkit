import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exif_toolkit/pages/login_page.dart';
import 'package:exif_toolkit/pages/signup_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseFirestore.instance.settings =
      const Settings(persistenceEnabled: true);
  FlutterNativeSplash.remove();
  runApp(const EXIFDataManipulatorApp());
}

class EXIFDataManipulatorApp extends StatelessWidget {
  const EXIFDataManipulatorApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: const [Locale('en')],
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: false,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFFFFFF), // Pure white background
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.robotoTextTheme(
          Theme.of(context).textTheme,
        ).copyWith(
          headlineMedium: const TextStyle(
            fontFamily: 'SF Pro Display', // If you have the SF Pro font
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          bodyMedium: const TextStyle(
            fontFamily: 'SF Pro Text', // If you have the SF Pro font
            fontSize: 16,
            color: Colors.black,
          ),
          labelLarge: const TextStyle(
            fontFamily: 'SF Pro Text', // If you have the SF Pro font
            color: Colors.white,
          ),
        ),
        scaffoldBackgroundColor: Colors.white,
        // Pure white background
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0.5, // Subtle elevation for iOS look
          titleTextStyle: TextStyle(
            fontFamily: 'SF Pro Display', // If you have the SF Pro font
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.black),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF007AFF), // iOS blue
            foregroundColor: Colors.white,
            textStyle: const TextStyle(
              fontFamily: 'SF Pro Text', // If you have the SF Pro font
            ),
          ),
        ),
        pageTransitionsTheme: PageTransitionsTheme(
          builders: Map<TargetPlatform, PageTransitionsBuilder>.fromIterable(
            TargetPlatform.values,
            value: (dynamic _) => const CupertinoPageTransitionsBuilder(),
          ),
        ),
        // Add more Cupertino-specific styling as needed
        cupertinoOverrideTheme: const CupertinoThemeData(
          primaryColor: Color(0xFF007AFF), // iOS blue as primary color
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
