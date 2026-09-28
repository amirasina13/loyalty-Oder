import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../../data/data.dart';

@immutable
class ProfileState extends Equatable {
  @override
  List<Object> get props => [];
}

@immutable
class ProfileInitial extends ProfileState {}

@immutable
class ProfileProcessing extends ProfileState {}

@immutable
class ProfileReload extends ProfileState {}

@immutable
class ProfileReloading extends ProfileState {}

@immutable
class ProfilePhotoUpdating extends ProfileState {}

@immutable
class ProfileUpdating extends ProfileState {}

@immutable
class ProfileAddressUpdating extends ProfileState {}

@immutable
class ProfilePasswordChanging extends ProfileState {}

@immutable
class ProfileEditLoaded extends ProfileState {
  final String errorField;

  ProfileEditLoaded({required this.errorField});

  @override
  String toString() => 'Profile Edited Loaded';

  @override
  List<Object> get props => [errorField];
}

@immutable
class ProfileLoaded extends ProfileState {
  final UserProfile userProfile;

  ProfileLoaded({required this.userProfile});

  @override
  String toString() => 'Profile Loaded';

  @override
  List<Object> get props => [userProfile];
}

@immutable
class ProfileUpdated extends ProfileState {}

@immutable
class ProfileRegUpdated extends ProfileState {
  final Map dataUpdated;

  ProfileRegUpdated({required this.dataUpdated});

  @override
  String toString() => 'Profile Register Updated';

  @override
  List<Object> get props => [dataUpdated];
}

@immutable
class ProfilePhotoUpdated extends ProfileState {}

@immutable
class ProfileError extends ProfileState {
  final String error;

  ProfileError({required this.error});

  @override
  List<Object> get props => [error];
}

@immutable
class ProfilePhotoError extends ProfileState {
  final String error;

  ProfilePhotoError({required this.error});

  @override
  List<Object> get props => [error];
}

@immutable
class ProfileNetworkError extends ProfileState {
  final String error;

  ProfileNetworkError({required this.error});

  @override
  List<Object> get props => [error];
}

@immutable
class ProfileSessionError extends ProfileState {
  final String error;

  ProfileSessionError({required this.error});

  @override
  List<Object> get props => [error];
}

@immutable
class ProfileException extends ProfileState {
  final String error;

  ProfileException({required this.error});

  @override
  List<Object> get props => [error];
}

@immutable
class ProfileMaintenanceError extends ProfileState {
  final String message;

  ProfileMaintenanceError({required this.message});

  @override
  List<Object> get props => [message];
}

@immutable
class ProfileWalletLoading extends ProfileState {}
