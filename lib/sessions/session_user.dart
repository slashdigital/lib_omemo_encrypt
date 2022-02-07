class SessionUser {
  final String name;
  final String deviceId;

  const SessionUser({required this.name, required this.deviceId});

  @override
  String toString() {
    return 'User: $name, Device: $deviceId';
  }
}
