import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exif_toolkit/models/devices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer';

const String DEVICE_COLLECTION_REF = 'devices';

class DatabaseService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  late final CollectionReference _deviceRef;

  DatabaseService() {
    _deviceRef = _firestore
        .collection(DEVICE_COLLECTION_REF)
        .withConverter<Device>(
            fromFirestore: (snapshot, _) => Device.fromJson(snapshot.data()!),
            toFirestore: (device, _) => device.toJson());
  }

  Stream<QuerySnapshot> getDevices() {
    String? userId = _auth.currentUser?.uid;

    return _deviceRef.where('userId', isEqualTo: userId).snapshots();
  }

  Future<void> addDevice(Device device) async {
    String? userId = _auth.currentUser?.uid;

    device = device.copyWith(userId: userId);
    try {
      await _deviceRef.add(device);
    } catch (e) {
      log('Error adding device to Firestore: $e');
    }
  }

  Future<bool> isDeviceRegistered(String userId, String deviceId) async {
    QuerySnapshot snapshot = await _deviceRef
        .where('userId', isEqualTo: userId)
        .where('deviceId', isEqualTo: deviceId)
        .get();

    return snapshot.docs.isNotEmpty;
  }
}
