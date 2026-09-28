import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class SecurityState extends Equatable {
  @override
  List<Object> get props => [];
}

@immutable
class SecurityInitial extends SecurityState {}

@immutable
class SecurityProcessing extends SecurityState {}

@immutable
class VerifyPinProcessing extends SecurityState {}

@immutable
class SecurityCheckVerified extends SecurityState {
  final bool verified;

  SecurityCheckVerified({required this.verified});

  @override
  String toString() => 'SecurityCheckVerified';

  @override
  List<Object> get props => [verified];
}

@immutable
class SecurityOtpSent extends SecurityState {
  final dynamic data;

  SecurityOtpSent(this.data);

  @override
  List<Object> get props => [data];
}

@immutable
class SecurityOtpVerified extends SecurityState {
  final dynamic data;

  SecurityOtpVerified(this.data);

  @override
  List<Object> get props => [data];
}

@immutable
class SecurityPinCreated extends SecurityState {
  final dynamic data;

  SecurityPinCreated(this.data);

  @override
  List<Object> get props => [data];
}

@immutable
class SecurityPinVerified extends SecurityState {
  final dynamic data;

  SecurityPinVerified(this.data);

  @override
  List<Object> get props => [data];
}

@immutable
class SecurityError extends SecurityState {
  final String error;

  SecurityError(this.error);

  @override
  List<Object> get props => [error];
}

@immutable
class SecurityNetworkError extends SecurityState {
  final String error;

  SecurityNetworkError(this.error);

  @override
  List<Object> get props => [error];
}

@immutable
class SecuritySessionError extends SecurityState {
  final String error;

  SecuritySessionError({required this.error});

  @override
  List<Object> get props => [
        error,
      ];
}

@immutable
class SecurityMaintenanceError extends SecurityState {
  final String message;

  SecurityMaintenanceError({required this.message});

  @override
  List<Object> get props => [
        message,
      ];
}
