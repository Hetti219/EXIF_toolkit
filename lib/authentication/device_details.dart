import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';
import 'package:flutter/material.dart';

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
      } else if (Platform.isFuchsia) {
        WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
        deviceId = webBrowserInfo.vendor;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        'Error sending Account Device Reset email: $e',
        style: Theme.of(context).textTheme.bodyMedium,
      )));
    }

    return deviceId;
  }
}
