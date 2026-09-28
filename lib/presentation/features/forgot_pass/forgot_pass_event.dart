import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class ForgotPassEvent extends Equatable {
  @override
  List<Object> get props => [];
}

@immutable
class ForgotPassReset extends ForgotPassEvent {
  final String? email;
  final String? contact;
  ForgotPassReset({this.email, this.contact});

  @override
  List<Object> get props => [email ?? '', contact ?? ''];

  @override
  String toString() => 'PasswordReset';
}

@immutable
class ForgotPassOtpSend extends ForgotPassEvent {
  final String password;
  final String otpCode;
  final String verifyToken;

  ForgotPassOtpSend({
    required this.password,
    required this.otpCode,
    required this.verifyToken,
  });

  @override
  List<Object> get props => [password, otpCode, verifyToken];

  @override
  String toString() => 'PasswordOtpSend';
}

@immutable
class ForgotPassOtpResend extends ForgotPassEvent {
  final String purpose;

  ForgotPassOtpResend({required this.purpose});

  @override
  List<Object> get props => [purpose];
}
