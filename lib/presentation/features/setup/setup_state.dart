import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class SetupState extends Equatable {
  @override
  List<Object> get props => [];
}

@immutable
class SetupInitial extends SetupState {}

@immutable
class SetupProcessing extends SetupState {}

@immutable
class SetupEmailDone extends SetupState {
  final dynamic data;

  SetupEmailDone(this.data);

  @override
  List<Object> get props => [data];
}

@immutable
class SetupContactDone extends SetupState {
  final dynamic data;

  SetupContactDone(this.data);

  @override
  List<Object> get props => [data];
}

@immutable
class SetupMuslimFriendlyDone extends SetupState {
  final dynamic data;

  SetupMuslimFriendlyDone(this.data);

  @override
  List<Object> get props => [data];
}

@immutable
class SetupEmailOtp extends SetupState {
  final dynamic data;

  SetupEmailOtp(this.data);

  @override
  List<Object> get props => [data];
}

@immutable
class SetupContactOtp extends SetupState {
  final dynamic data;

  SetupContactOtp(this.data);

  @override
  List<Object> get props => [data];
}

@immutable
class SetupSent extends SetupState {
  final dynamic data;

  SetupSent(this.data);

  @override
  List<Object> get props => [data];
}

@immutable
class SetupError extends SetupState {
  final String error;

  SetupError(this.error);

  @override
  List<Object> get props => [error];
}

@immutable
class SetupFinished extends SetupState {
  final dynamic data;

  SetupFinished(this.data);

  @override
  List<Object> get props => [data];
}

@immutable
class SetupNetworkError extends SetupState {
  final String error;

  SetupNetworkError({required this.error});

  @override
  List<Object> get props => [
        error,
      ];
}

@immutable
class SetupMaintenanceError extends SetupState {
  final String message;

  SetupMaintenanceError({required this.message});

  @override
  List<Object> get props => [
        message,
      ];
}
