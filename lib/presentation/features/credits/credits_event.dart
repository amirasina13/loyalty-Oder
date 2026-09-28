import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/* Events tell BLoC to do something. An event can be fired from anywhere, such as from a UI widget. 
External events, such as changes in network connectivity, changes in sensor readings */

/* Events class are an application’s inputs (like button_press to load images, text inputs, or any 
other user input that our app may hope to receive) */

@immutable
abstract class CreditEvent extends Equatable {
  @override
  List<Object> get props => [];
}

@immutable
class CreditLoad extends CreditEvent {}

@immutable
class CreditTopupLoad extends CreditEvent {}

@immutable
class PointConvertLoad extends CreditEvent {
  final String pin;
  final String pointConvert;

  PointConvertLoad({
    required this.pin,
    required this.pointConvert,
  });

  @override
  List<Object> get props => [
        pin,
        pointConvert,
      ];
}

@immutable
class CreditPaymentLoad extends CreditEvent {}

@immutable
class CreditOnlineLoad extends CreditEvent {
  final String amount;

  CreditOnlineLoad({required this.amount});

  @override
  List<Object> get props => [
        amount,
      ];
}
