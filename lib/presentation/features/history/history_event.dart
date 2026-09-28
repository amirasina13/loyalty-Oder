import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class HistoryEvent extends Equatable {
  @override
  List<Object> get props => [];
}

@immutable
class HistoryTransactionsLoad extends HistoryEvent {}

@immutable
class CreditHistoryTransactionsLoad extends HistoryEvent {}

@immutable
class WalletCreditHistoryTransactionsLoad extends HistoryEvent {
  final String offset;

  WalletCreditHistoryTransactionsLoad({required this.offset});

  @override
  List<Object> get props => [
        offset,
      ];
}

@immutable
class HistoryLoad extends HistoryEvent {
  final bool tab;

  HistoryLoad({required this.tab});

  @override
  List<Object> get props => [
        tab,
      ];
}
