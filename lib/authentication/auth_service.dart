import 'dart:async';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final credentials = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      return credentials.user;
    } catch (e) {
      log('Unexpected Sign Up Error: $e');
      rethrow;
    }
  }

  Future<User?> loginUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      return cred.user;
    } catch (e) {
      log("Log In Error Detected: $e");
    }
    return null;
  }

/*FutureOr<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      log('Sign out error detected');
    }
  }*/
}
