import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class VerifyEmailState extends Equatable {
  @override
  List<Object> get props => [];
}

@immutable
class VerifyEmailInitial extends VerifyEmailState {
  @override
  String toString() => 'VerifyEmailInitial';
}

@immutable
class VerifyEmailError extends VerifyEmailState {
  final String error;

  VerifyEmailError(this.error);

  @override
  List<Object> get props => [error];
}

@immutable
class VerifyEmailProcessing extends VerifyEmailState {}

@immutable
class VerifyEmailSent extends VerifyEmailState {
  final dynamic data;

  VerifyEmailSent(this.data);

  @override
  List<Object> get props => [data];
}

@immutable
class VerifyEmailOtpVerified extends VerifyEmailState {
  final dynamic data;

  VerifyEmailOtpVerified(this.data);

  @override
  List<Object> get props => [data];
}

@immutable
class VerifyNetworkError extends VerifyEmailState {
  final String error;

  VerifyNetworkError(this.error);

  @override
  List<Object> get props => [error];
}

@immutable
class VerifyEmailMaintenanceError extends VerifyEmailState {
  final String message;

  VerifyEmailMaintenanceError({required this.message});

  @override
  List<Object> get props => [
        message,
      ];
}
