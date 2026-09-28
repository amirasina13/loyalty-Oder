import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class VerifyEmailEvent extends Equatable {
  @override
  List<Object> get props => [];
}

@immutable
class VerifyEmailSend extends VerifyEmailEvent {
  final String email;

  VerifyEmailSend({required this.email});

  @override
  List<Object> get props => [
        email,
      ];

  @override
  String toString() => 'HomeLoad';
}

@immutable
class VerifyEmailOtpSend extends VerifyEmailEvent {
  final String otpCode;

  VerifyEmailOtpSend({required this.otpCode});

  @override
  List<Object> get props => [
        otpCode,
      ];
}

@immutable
class VerifyEmailOtpResend extends VerifyEmailEvent {
  final String purpose;
  final String contactNo;
  final String vToken;

  VerifyEmailOtpResend({
    required this.purpose,
    required this.contactNo,
    required this.vToken,
  });

  @override
  List<Object> get props => [
        purpose,
        contactNo,
        vToken,
      ];
}
