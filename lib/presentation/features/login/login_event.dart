import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class LoginEvent extends Equatable {
  @override
  List<Object> get props => [];
}

@immutable
class LoginLoad extends LoginEvent {}

@immutable
class LoginPressed extends LoginEvent {
  final String? email;
  final String? contact;
  final String password;

  LoginPressed({this.email, this.contact, required this.password});

  @override
  List<Object> get props => [email ?? '', contact ?? '', password];
}
