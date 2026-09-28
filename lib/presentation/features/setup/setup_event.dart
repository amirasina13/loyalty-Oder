import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class SetupEvent extends Equatable {
  @override
  List<Object> get props => [];
}

@immutable
class SetupLoad extends SetupEvent {}

@immutable
class SetupEmail extends SetupEvent {
  final String email;

  SetupEmail({required this.email});

  @override
  List<Object> get props => [email];
}

@immutable
class SetupContact extends SetupEvent {
  final String contact;

  SetupContact({required this.contact});

  @override
  List<Object> get props => [contact];
}

@immutable
class SetupMuslimFriendly extends SetupEvent {
  final bool isMuslim;

  SetupMuslimFriendly({required this.isMuslim});

  @override
  List<Object> get props => [isMuslim];
}

@immutable
class SetupVerify extends SetupEvent {
  final String otpCode;

  SetupVerify({required this.otpCode});

  @override
  List<Object> get props => [
        otpCode,
      ];
}

// @immutable
// class SetupSend extends SetupEvent {
//   final String contact;
//   final String purpose;

//   SetupSend({required this.contact, required this.purpose});

//   @override
//   List<Object> get props => [contact, purpose];
// }

@immutable
class SetupResend extends SetupEvent {
  final String purpose;
  final String contactNo;
  final String vToken;

  SetupResend({
    required this.purpose,
    required this.contactNo,
    required this.vToken,
  });

  @override
  List<Object> get props => [
        purpose,
        contactNo,
        vToken,
      ];
}
