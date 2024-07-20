import 'dart:async';
import 'dart:developer';
import 'package:exif_toolkit/authentication/device_details.dart';
import 'package:exif_toolkit/models/devices.dart';
import 'package:exif_toolkit/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _deviceId = DeviceDetails().getDeviceId();
  final _databaseService = DatabaseService();

  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final credentials = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      final userId = credentials.user?.uid;
      final deviceId = await _deviceId;

      if (userId != null && deviceId != null) {
        final device = Device(userId: userId, deviceId: deviceId);
        await _databaseService.addDevice(device);
      } else {
        throw Exception('Error: userId or deviceId is null during signup.');
      }
      return credentials.user;
    } on FirebaseAuthException catch (e) {
      log('Sign up error: ${e.code} - ${e.message}');
      rethrow; // Rethrow for UI handling
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
      final userId = cred.user?.uid;
      final deviceId = await _deviceId;

      if (userId != null && deviceId != null) {
        final isRegistered =
            await _databaseService.isDeviceRegistered(userId, deviceId);
        if (!isRegistered) {
          await signOut(); // Sign the user out immediately
          throw Exception('This device is not registered for this account.');
        }
        return cred.user;
      } else {
        log("Error: userId or deviceId is null during login.");
        throw Exception('Login failed due to missing credentials.');
      }
    } on FirebaseAuthException catch (e) {
      log('Log In Error: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      log("Log In Error Detected: $e");
      rethrow;
    }
  }

  FutureOr<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      log('Sign out error detected');
    }
  }
}
