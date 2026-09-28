import 'package:equatable/equatable.dart';
// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

/* States represent the information to be processed by any widget. A widget changes itself based on the state. */
/* States are simply the application’s state, which can be changed in response to the event received. */

@immutable
abstract class AuthenticationState extends Equatable {
  @override
  List<Object> get props => [];
}

@immutable
class AuthenticationUninitialized extends AuthenticationState {}

@immutable
class AuthenticationAuthenticated extends AuthenticationState {
  final Map loginData;

  AuthenticationAuthenticated({required this.loginData});

  @override
  List<Object> get props => [loginData];
}

@immutable
class AuthenticationChecked extends AuthenticationState {
  final Map loginData;

  AuthenticationChecked({required this.loginData});

  @override
  List<Object> get props => [loginData];
}

@immutable
class AuthenticationUnauthenticated extends AuthenticationState {}

@immutable
class AuthenticationOnBoardingStarted extends AuthenticationState {}

@immutable
class AuthenticationError extends AuthenticationState {
  final String error;

  AuthenticationError({required this.error});

  @override
  List<Object> get props => [error];
}

@immutable
class AuthMaintenanceError extends AuthenticationState {
  final String message;

  AuthMaintenanceError({required this.message});

  @override
  List<Object> get props => [message];
}

@immutable
class NetworkError extends AuthenticationState {
  final String error;

  NetworkError({required this.error});

  @override
  List<Object> get props => [error];
}
