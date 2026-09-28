import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../data/data.dart';

@immutable
abstract class OutletState extends Equatable {
  @override
  List<Object> get props => [];
}

@immutable
class OutletInitial extends OutletState {}

@immutable
class OutletLoading extends OutletState {}

@immutable
class OutletStarted extends OutletState {}

@immutable
class OutletLocationRequested extends OutletState {}

@immutable
class OutletEnableStarted extends OutletState {}

@immutable
class OutletAllLoaded extends OutletState {}

@immutable
class OutletEmpty extends OutletState {}

@immutable
class OutletDetailsEmpty extends OutletState {}

@immutable
class OutletDetailsLoading extends OutletState {}

@immutable
class OutletDetailsLoaded extends OutletState {
  final OutletDetails details;

  OutletDetailsLoaded({required this.details});

  @override
  List<Object> get props => [details];

  @override
  String toString() => 'Outlet Details Loaded';
}

@immutable
class OutletError extends OutletState {
  final String error;

  OutletError({required this.error});

  @override
  List<Object> get props => [error];
}

@immutable
class OutletNetworkError extends OutletState {
  final String error;

  OutletNetworkError({required this.error});

  @override
  List<Object> get props => [error];
}

@immutable
class OutletSessionError extends OutletState {
  final String error;

  OutletSessionError({required this.error});

  @override
  List<Object> get props => [error];
}

@immutable
class OutletMaintenanceError extends OutletState {
  final String message;

  OutletMaintenanceError({required this.message});

  @override
  List<Object> get props => [message];
}

@immutable
class OutletLocationDisabled extends OutletState {}
