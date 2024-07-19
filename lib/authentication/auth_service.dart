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

  FutureOr<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final credentials = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      String? userId = credentials.user?.uid;
      String? deviceId = await _deviceId;

      if (userId != null && deviceId != null) {
        Device device = Device(userId: userId, deviceId: deviceId);
        await _databaseService.addDevice(device);
      } else {
        // Handle the case where userId or deviceId is null (e.g., log an error)
        log("Error: userId or deviceId is null during signup.");
        // Optionally, throw an exception or show an error message to the user
      }
      return credentials.user;
    } catch (e) {
      log('Sign up error detected: $e');
    }

    return null;
  }

  FutureOr<User?> loginUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      String? userId = cred.user?.uid;
      String? deviceId = await _deviceId;

      if (userId != null && deviceId != null) {
        if (!(await _databaseService.isDeviceRegistered(userId, deviceId))) {
          // Device not registered, deny access
          await signOut(); // Sign the user out immediately
          throw Exception('This device is not registered for this account.');
        }
        return cred.user;
      } else {
        // Handle the case where userId or deviceId is null
        log("Error: userId or deviceId is null during login.");
        // Optionally, throw an exception or show an error message to the user
      }
    } catch (e) {
      log("Log In Error Detected: $e"); // Log error details
      rethrow; // Rethrow the error to be handled by the UI
    }

    return null; // Indicate login failure
  }

  FutureOr<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      log('Sign out error detected');
    }
  }
}
