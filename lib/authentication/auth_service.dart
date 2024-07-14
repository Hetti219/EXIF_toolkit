import 'dart:async';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final auth = FirebaseAuth.instance;

  FutureOr<User?> createUserWithEmailAndDeviceId(
      String email, String deviceId) async {
    try {
      final credentials = await auth.createUserWithEmailAndPassword(
          email: email, password: deviceId);
      return credentials.user;
    } catch (e) {
      log('Sign in error detected');
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
