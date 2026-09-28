import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class SecurityEvent extends Equatable {
  @override
  List<Object> get props => [];
}

@immutable
class SecurityStart extends SecurityEvent {
  @override
  String toString() => 'SecurityStart';
}

@immutable
class SecurityLoad extends SecurityEvent {}

@immutable
class SecurityOtpSend extends SecurityEvent {}

@immutable
class SecurityOtpResend extends SecurityEvent {}

@immutable
class SecurityOtpVerify extends SecurityEvent {
  final String otp;
  final String otpToken;

  SecurityOtpVerify({
    required this.otp,
    required this.otpToken,
  });

  @override
  List<Object> get props => [otp, otpToken];
}

@immutable
class SecurityCreatePin extends SecurityEvent {
  final String pin;

  SecurityCreatePin({
    required this.pin,
  });

  @override
  List<Object> get props => [pin];
}

@immutable
class SecurityPinVerify extends SecurityEvent {
  final String pin;

  SecurityPinVerify({
    required this.pin,
  });

  @override
  List<Object> get props => [pin];
}
