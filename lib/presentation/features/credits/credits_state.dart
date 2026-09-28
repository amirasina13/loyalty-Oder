import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../data/data.dart';

/* States represent the information to be processed by any widget. A widget changes itself based on the state. */
/* States are simply the application’s state, which can be changed in response to the event received. */

@immutable
abstract class CreditState extends Equatable {
  @override
  List<Object> get props => [];
}

@immutable
class CreditInitial extends CreditState {}

@immutable
class CreditLoading extends CreditState {}

@immutable
class CreditTopupEmpty extends CreditState {}

@immutable
class CreditPaymentEmpty extends CreditState {}

@immutable
class CreditPaymentLoaded extends CreditState {
  final CreditPayment details;

  CreditPaymentLoaded({required this.details});

  @override
  List<Object> get props => [details];

  @override
  String toString() => 'Credit Payment Loaded';
}

@immutable
class CreditOnlineLoaded extends CreditState {
  final String url;

  CreditOnlineLoaded({required this.url});

  @override
  List<Object> get props => [url];

  @override
  String toString() => 'Credit Online Topup Loaded';
}

@immutable
class ConvertSuccess extends CreditState {
  final String message;

  ConvertSuccess(this.message);

  @override
  List<Object> get props => [message];
}

@immutable
class CreditError extends CreditState {
  final String error;

  CreditError({required this.error});

  @override
  List<Object> get props => [error];
}

@immutable
class CreditNetworkError extends CreditState {
  final String error;

  CreditNetworkError({required this.error});

  @override
  List<Object> get props => [error];
}

@immutable
class CreditSessionError extends CreditState {
  final String error;

  CreditSessionError({required this.error});

  @override
  List<Object> get props => [error];
}

@immutable
class CreditMaintenanceError extends CreditState {
  final String message;

  CreditMaintenanceError({required this.message});

  @override
  List<Object> get props => [message];
}
