class Device {
  String userId;
  String deviceId;

  Device({required this.userId, required this.deviceId});

  Device.fromJson(Map<String, Object?> json)
      : this(
            userId: json['userId'] as String,
            deviceId: json['deviceId'] as String);

  Device copyWith({String? userId, String? deviceId}) {
    return Device(
        userId: userId ?? this.userId, deviceId: deviceId ?? this.deviceId);
  }

  Map<String, Object?> toJson() {
    return {'userId': userId, 'deviceId': deviceId};
  }
}
