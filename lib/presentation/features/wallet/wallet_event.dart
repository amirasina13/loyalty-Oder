import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class WalletEvent extends Equatable {
  @override
  List<Object> get props => [];
}

@immutable
class WalletStart extends WalletEvent {}

@immutable
class WalletPaymentInit extends WalletEvent {
  final String amount;

  WalletPaymentInit({required this.amount});

  @override
  List<Object> get props => [
        amount,
      ];
}

@immutable
class WalletLoad extends WalletEvent {}
