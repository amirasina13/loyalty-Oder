import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class OtpState extends Equatable {
  @override
  List<Object> get props => [];
}

@immutable
class OtpInitial extends OtpState {}

@immutable
class OtpProcessing extends OtpState {}

@immutable
class OtpRequestSuccess extends OtpState {
  final Map data;

  OtpRequestSuccess(this.data);

  @override
  List<Object> get props => [data];
}

@immutable
class OtpResent extends OtpState {
  final Map data;

  OtpResent(this.data);

  @override
  List<Object> get props => [data];
}

@immutable
class OtpError extends OtpState {
  final String error;

  OtpError(this.error);

  @override
  List<Object> get props => [error];
}

@immutable
class OtpFinished extends OtpState {
  final String message;

  OtpFinished(this.message);

  @override
  List<Object> get props => [message];
}

@immutable
class OtpMaintenanceError extends OtpState {
  final String message;

  OtpMaintenanceError({required this.message});

  @override
  List<Object> get props => [
        message,
      ];
}
