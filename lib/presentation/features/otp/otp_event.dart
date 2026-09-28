import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class OtpEvent extends Equatable {
  @override
  List<Object> get props => [];
}

@immutable
class OtpLoad extends OtpEvent {}

@immutable
class OtpRequest extends OtpEvent {
  final String method;
  final String sendvia;
  final String purpose;
  final String vToken;

  OtpRequest({
    required this.method,
    required this.sendvia,
    required this.purpose,
    required this.vToken,
  });

  @override
  List<Object> get props => [method, sendvia, purpose, vToken];
}

@immutable
class OtpVerify extends OtpEvent {
  final String otpCode;
  final String token;

  OtpVerify({required this.otpCode, required this.token});

  @override
  List<Object> get props => [otpCode];
}

@immutable
class OtpResend extends OtpEvent {
  final String method;
  final String sendvia;
  final String purpose;
  final String vToken;

  OtpResend({
    required this.method,
    required this.sendvia,
    required this.purpose,
    required this.vToken,
  });

  @override
  List<Object> get props => [method, sendvia, purpose, vToken];
}
