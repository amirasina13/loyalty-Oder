import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../../data/data.dart';

@immutable
class ReferState extends Equatable {
  @override
  List<Object> get props => [];
}

@immutable
class ReferInitial extends ReferState {}

@immutable
class ReferProcessing extends ReferState {}

@immutable
class ReferLoaded extends ReferState {
  final UserRefer userRefer;

  ReferLoaded({required this.userRefer});

  @override
  String toString() => 'Refer Loaded';

  @override
  List<Object> get props => [userRefer];
}

@immutable
class ReferError extends ReferState {
  final String error;

  ReferError({required this.error});

  @override
  List<Object> get props => [error];
}

@immutable
class ReferNetworkError extends ReferState {
  final String error;

  ReferNetworkError({required this.error});

  @override
  List<Object> get props => [error];
}

@immutable
class ReferSessionError extends ReferState {
  final String error;

  ReferSessionError({required this.error});

  @override
  List<Object> get props => [error];
}

@immutable
class ReferException extends ReferState {
  final String error;

  ReferException({required this.error});

  @override
  List<Object> get props => [error];
}

@immutable
class ReferMaintenanceError extends ReferState {
  final String message;

  ReferMaintenanceError({required this.message});

  @override
  List<Object> get props => [message];
}
