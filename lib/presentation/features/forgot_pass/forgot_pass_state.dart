import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class ForgotPassState extends Equatable {
  @override
  List<Object> get props => [];
}

@immutable
class ForgotPassInitial extends ForgotPassState {}

@immutable
class ForgotPassError extends ForgotPassState {
  final String error;

  ForgotPassError(this.error);

  @override
  List<Object> get props => [error];
}

@immutable
class ForgotPassFinished extends ForgotPassState {}

@immutable
class ForgotPassProcessing extends ForgotPassState {}

@immutable
class ForgotPassSent extends ForgotPassState {
  final Map data;

  ForgotPassSent(this.data);

  @override
  List<Object> get props => [data];
}

@immutable
class ForgotPassResent extends ForgotPassState {
  final Map data;

  ForgotPassResent(this.data);

  @override
  List<Object> get props => [data];
}

@immutable
class ForgotPassOtpVerified extends ForgotPassState {
  final String message;

  ForgotPassOtpVerified({required this.message});

  @override
  List<Object> get props => [
        message,
      ];
}

@immutable
class ForgotPassMaintenanceError extends ForgotPassState {
  final String message;

  ForgotPassMaintenanceError({required this.message});

  @override
  List<Object> get props => [
        message,
      ];
}
