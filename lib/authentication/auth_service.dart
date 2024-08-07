import 'dart:async';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:local_auth/local_auth.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final LocalAuthentication _bio = LocalAuthentication();

  FutureOr<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return cred.user;
    } catch (e) {
      log("Sign Up Error Detected");
    }
    return null;
  }

  FutureOr<User?> loginUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return cred.user;
    } catch (e) {
      log("Log In Error Detected");
    }
    return null;
  }

  FutureOr<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      log("Sign Out Error Detected");
    }
  }

  Future<bool> authenticateWithBiometrics() async {
    try {
      return await _bio.authenticate(
          localizedReason: 'Please authenticate to proceed',
          options: const AuthenticationOptions(
              biometricOnly: true, stickyAuth: true));
    } catch (e) {
      log('$e');
      return false;
    }
  }
}
