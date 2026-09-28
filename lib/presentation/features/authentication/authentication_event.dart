import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/* Events tell BLoC to do something. An event can be fired from anywhere, such as from a UI widget. 
External events, such as changes in network connectivity, changes in sensor readings */

/* Events class are an application’s inputs (like button_press to load images, text inputs, or any 
other user input that our app may hope to receive) */

@immutable
abstract class AuthenticationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

@immutable
class AuthenticationAppStarted extends AuthenticationEvent {
  @override
  String toString() => 'AuthenticationAppStarted';
}

@immutable
class AuthenticationOnBoardingStart extends AuthenticationEvent {
  @override
  String toString() => 'AuthenticationOnBoardingStart';
}

@immutable
class AuthenticationOnBoardingComplete extends AuthenticationEvent {
  @override
  String toString() => 'AuthenticationOnBoardingComplete';
}

@immutable
class AuthenticationLoggedIn extends AuthenticationEvent {
  final String token;
  final Map loginData;

  AuthenticationLoggedIn({required this.token, required this.loginData});

  @override
  List<Object> get props => [token, loginData];

  @override
  String toString() => 'AuthenticationLoggedIn';
}

@immutable
class AuthenticationLoggedOut extends AuthenticationEvent {
  @override
  String toString() => 'AuthenticationLoggedOut';
}

@immutable
class AuthenticationChecking extends AuthenticationEvent {
  @override
  String toString() => 'AuthenticationChecking';
}
