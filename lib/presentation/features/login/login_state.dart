import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class LoginState extends Equatable {
  @override
  List<Object> get props => [];
}

@immutable
class LoginInitial extends LoginState {}

@immutable
class LoginLoaded extends LoginState {}

@immutable
class LoginProcessing extends LoginState {}

@immutable
class LoginError extends LoginState {
  final String error;

  LoginError(this.error);

  @override
  List<Object> get props => [error];
}

@immutable
class LoginNetworkError extends LoginState {
  final String error;

  LoginNetworkError(this.error);

  @override
  List<Object> get props => [error];
}

@immutable
class LoginFinished extends LoginState {
  final Map loginData;

  LoginFinished(this.loginData);

  @override
  List<Object> get props => [loginData];
}

@immutable
class LoginMaintenanceError extends LoginState {
  final String message;

  LoginMaintenanceError({required this.message});

  @override
  List<Object> get props => [
        message,
      ];
}
