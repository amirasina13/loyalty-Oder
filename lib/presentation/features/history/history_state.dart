import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../data/data.dart';

@immutable
abstract class HistoryState extends Equatable {
  @override
  List<Object> get props => [];
}

@immutable
class HistoryInitial extends HistoryState {}

@immutable
class HistoryLoading extends HistoryState {}

@immutable
class HistoryPointNextLoading extends HistoryState {}

@immutable
class HistoryCreditNextLoading extends HistoryState {}

@immutable
class HistoryTransactionsLoaded extends HistoryState {
  final History history;

  HistoryTransactionsLoaded({required this.history});

  @override
  List<Object> get props => [history];

  @override
  String toString() => '${history.records!.length} History List Loaded';
}

@immutable
class CreditHistoryTransactionsLoaded extends HistoryState {
  final CreditHistory history;

  CreditHistoryTransactionsLoaded({required this.history});

  @override
  List<Object> get props => [history];

  @override
  String toString() => '${history.records!.length} Credit History List Loaded';
}

@immutable
class WalletCreditHistoryTransactionsLoaded extends HistoryState {
  final CreditHistory history;

  WalletCreditHistoryTransactionsLoaded({required this.history});

  @override
  List<Object> get props => [history];

  @override
  String toString() =>
      '${history.records!.length} Wallet Credit History List Loaded';
}

@immutable
class HistoryEmpty extends HistoryState {}

@immutable
class CreditHistoryEmpty extends HistoryState {}

@immutable
class HistoryDetailsEmpty extends HistoryState {}

@immutable
class HistoryListStop extends HistoryState {}

@immutable
class HistoryListNext extends HistoryState {}

@immutable
class CreditHistoryListStop extends HistoryState {}

@immutable
class HistoryDetailsLoading extends HistoryState {}

@immutable
class HistoryPurchaseSuccess extends HistoryState {}

@immutable
class HistoryError extends HistoryState {
  final String error;

  HistoryError({required this.error});

  @override
  List<Object> get props => [error];
}

@immutable
class HistoryNetworkError extends HistoryState {
  final String error;

  HistoryNetworkError({required this.error});

  @override
  List<Object> get props => [error];
}

@immutable
class HistorySessionError extends HistoryState {
  final String error;

  HistorySessionError({required this.error});

  @override
  List<Object> get props => [error];
}

@immutable
class HistoryMaintenanceError extends HistoryState {
  final String message;

  HistoryMaintenanceError({required this.message});

  @override
  List<Object> get props => [message];
}
