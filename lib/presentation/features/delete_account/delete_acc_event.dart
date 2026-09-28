import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class DeleteAccEvent extends Equatable {
  @override
  List<Object> get props => [];
}

@immutable
class DeleteAccReason extends DeleteAccEvent {
  final String reason;

  DeleteAccReason({required this.reason});

  @override
  List<Object> get props => [
        reason,
      ];

  @override
  String toString() => 'DeleteAccReasonLoad';
}

// @immutable
// class DeleteAccMobile extends DeleteAccEvent {
//   final String mobileNo;

//   DeleteAccMobile({required this.mobileNo});

//   @override
//   List<Object> get props => [
//         mobileNo,
//       ];
// }

@immutable
class DeleteAccSend extends DeleteAccEvent {
  final String email;

  DeleteAccSend({required this.email});

  @override
  List<Object> get props => [email];
}
