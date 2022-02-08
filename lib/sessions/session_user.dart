import 'package:equatable/equatable.dart';

class SessionUser extends Equatable {
  final String name;
  final String deviceId;

  const SessionUser({required this.name, required this.deviceId});

  @override
  String toString() {
    return 'User: $name, Device: $deviceId';
  }

  @override
  List<Object?> get props => [name, deviceId];
}
