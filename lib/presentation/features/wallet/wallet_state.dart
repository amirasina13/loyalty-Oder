import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../data/data.dart';

@immutable
abstract class WalletState extends Equatable {
  @override
  List<Object> get props => [];
}

@immutable
class WalletInitial extends WalletState {}

@immutable
class WalletProcessing extends WalletState {}

@immutable
class WalletLoading extends WalletState {}

@immutable
class WalletError extends WalletState {
  final String error;

  WalletError({required this.error});

  @override
  List<Object> get props => [error];
}

@immutable
class WalletNetworkError extends WalletState {
  final String error;

  WalletNetworkError({required this.error});

  @override
  List<Object> get props => [error];
}

@immutable
class WalletSessionError extends WalletState {
  final String error;

  WalletSessionError({required this.error});

  @override
  List<Object> get props => [error];
}

@immutable
class WalletPaymentLoaded extends WalletState {
  final String url;

  WalletPaymentLoaded({required this.url});

  @override
  List<Object> get props => [url];
}

@immutable
class WalletLoaded extends WalletState {
  final UserQrcode userQrcode;

  WalletLoaded({required this.userQrcode});

  @override
  String toString() => 'Wallet Loaded';

  @override
  List<Object> get props => [userQrcode];
}

@immutable
class WalletMaintenanceError extends WalletState {
  final String message;

  WalletMaintenanceError({required this.message});

  @override
  List<Object> get props => [message];
}
