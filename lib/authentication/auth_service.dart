import 'dart:async';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final auth = FirebaseAuth.instance;

  FutureOr<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final credentials = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credentials.user;
    } catch (e) {
      log('Sign in error detected');
    }

    return null;
  }

  FutureOr<User?> loginUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      return cred.user;
    } catch (e) {
      log("Log In Error Detected");
    }
    return null;
  }

  FutureOr<void> signOut() async {
    try {
      await auth.signOut();
    } catch (e) {
      log('Sign out error detected');
    }
  }
}
