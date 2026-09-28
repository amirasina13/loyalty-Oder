import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class RegisterState extends Equatable {
  @override
  List<Object> get props => [];
}

@immutable
class RegisterInitial extends RegisterState {}

@immutable
class RegisterProcessing extends RegisterState {}

@immutable
class PhoneProcessing extends RegisterState {}

@immutable
class RegisterReviewLoading extends RegisterState {}

@immutable
class RegisterReviewLoaded extends RegisterState {
  final String code;
  final String contact;
  final String referral;
  final String password;

  RegisterReviewLoaded(
      {required this.code,
      required this.contact,
      required this.referral,
      required this.password});

  @override
  String toString() => 'RegisterReviewLoaded';

  @override
  List<Object> get props => [code, contact, referral, password];
}

@immutable
class RegisterVerifySuccess extends RegisterState {
  final Map data;

  RegisterVerifySuccess(this.data);

  @override
  List<Object> get props => [data];
}

@immutable
class RegisterSuccess extends RegisterState {
  final Map data;

  RegisterSuccess(this.data);

  @override
  List<Object> get props => [data];
}

@immutable
class ReferDecryptSuccess extends RegisterState {
  final String referCode;

  ReferDecryptSuccess({required this.referCode});

  @override
  String toString() => 'Code Decryption Loaded';

  @override
  List<Object> get props => [referCode];
}

@immutable
class ReferDecryptFail extends RegisterState {}

@immutable
class RegisterPassSent extends RegisterState {}

@immutable
class RegisterError extends RegisterState {
  final String error;

  RegisterError(this.error);

  @override
  List<Object> get props => [error];
}

@immutable
class RegisterNetworkError extends RegisterState {
  final String error;

  RegisterNetworkError(this.error);

  @override
  List<Object> get props => [error];
}

@immutable
class RegisterMaintenanceError extends RegisterState {
  final String message;

  RegisterMaintenanceError({required this.message});

  @override
  List<Object> get props => [
        message,
      ];
}

@immutable
class RegisterFinished extends RegisterState {}
