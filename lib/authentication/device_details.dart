import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

import 'package:flutter/foundation.dart';

class DeviceDetails {
  //Get device ID
  Future<String?> getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String? deviceId;

    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceId = androidInfo.id;
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor;
      }
    } catch (e) {
      // Handle the error here (consider logging or throwing an exception)
      if (kDebugMode) {
        print('Error getting device ID: $e');
      } // Log the error for debugging
    }

    return deviceId;
  }
}
