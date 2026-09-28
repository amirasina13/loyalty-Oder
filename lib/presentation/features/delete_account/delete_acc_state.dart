import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class DeleteAccState extends Equatable {
  @override
  List<Object> get props => [];
}

@immutable
class DeleteAccInitial extends DeleteAccState {
  @override
  String toString() => 'DeleteAccInitial';
}

@immutable
class DeleteAccError extends DeleteAccState {
  final String error;

  DeleteAccError(this.error);

  @override
  List<Object> get props => [error];
}

@immutable
class DeleteAccProcessing extends DeleteAccState {}

@immutable
class DeleteAccSent extends DeleteAccState {
  final String message;

  DeleteAccSent(this.message);

  @override
  List<Object> get props => [message];
}

@immutable
class AccReasonDeleted extends DeleteAccState {}

@immutable
class AccMobileDeleted extends DeleteAccState {
  final String contact;

  AccMobileDeleted(this.contact);

  @override
  List<Object> get props => [contact];
}

@immutable
class VerifyNetworkError extends DeleteAccState {
  final String error;

  VerifyNetworkError(this.error);

  @override
  List<Object> get props => [error];
}

@immutable
class DeleteAccMaintenanceError extends DeleteAccState {
  final String message;

  DeleteAccMaintenanceError({required this.message});

  @override
  List<Object> get props => [
        message,
      ];
}
