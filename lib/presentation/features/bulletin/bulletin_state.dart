import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../data/data.dart';

/* States represent the information to be processed by any widget. A widget changes itself based on the state. */
/* States are simply the application’s state, which can be changed in response to the event received. */

@immutable
abstract class BulletinState extends Equatable {
  @override
  List<Object> get props => [];
}

@immutable
class BulletinInitial extends BulletinState {}

@immutable
class BulletinLoading extends BulletinState {}

@immutable
class BulletinListLoaded extends BulletinState {
  final List<Bulletin> bulletins;

  BulletinListLoaded({required this.bulletins});

  @override
  List<Object> get props => [bulletins];

  @override
  String toString() => 'List Bulletin Loaded';
}

@immutable
class BulletinEmpty extends BulletinState {}

@immutable
class BulletinDetailsEmpty extends BulletinState {}

@immutable
class BulletinDetailsLoading extends BulletinState {}

@immutable
class BulletinDetailsLoaded extends BulletinState {
  final BulletinDetails details;

  BulletinDetailsLoaded({required this.details});

  @override
  List<Object> get props => [details];

  @override
  String toString() => 'Bulletin Details Loaded';
}

@immutable
class BulletinError extends BulletinState {
  final String error;

  BulletinError({required this.error});

  @override
  List<Object> get props => [error];
}

@immutable
class BulletinNetworkError extends BulletinState {
  final String error;

  BulletinNetworkError({required this.error});

  @override
  List<Object> get props => [error];
}

@immutable
class BulletinSessionError extends BulletinState {
  final String error;

  BulletinSessionError({required this.error});

  @override
  List<Object> get props => [error];
}

@immutable
class BulletinMaintenanceError extends BulletinState {
  final String message;

  BulletinMaintenanceError({required this.message});

  @override
  List<Object> get props => [message];
}
