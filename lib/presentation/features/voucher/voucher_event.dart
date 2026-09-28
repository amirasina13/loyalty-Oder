import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class VoucherEvent extends Equatable {
  @override
  List<Object> get props => [];
}

@immutable
class VoucherListLoad extends VoucherEvent {}

@immutable
class VoucherCategoriesLoad extends VoucherEvent {
  final String filterBy;
  final String filterValue;

  VoucherCategoriesLoad({required this.filterBy, required this.filterValue});
}

@immutable
class VoucherCategoryCount extends VoucherEvent {}

@immutable
class VoucherPastTransactionsLoad extends VoucherEvent {}

@immutable
class VoucherLoad extends VoucherEvent {}

@immutable
class VoucherOutletCheck extends VoucherEvent {}

@immutable
class VoucherDetailsLoad extends VoucherEvent {
  final String voucherId;

  VoucherDetailsLoad({required this.voucherId});

  @override
  List<Object> get props => [voucherId];
}

@immutable
class VoucherPastDetailsLoad extends VoucherEvent {
  final String voucherId;

  VoucherPastDetailsLoad({required this.voucherId});

  @override
  List<Object> get props => [voucherId];
}

@immutable
class VoucherQrLoad extends VoucherEvent {
  final int voucherId;

  VoucherQrLoad({required this.voucherId});

  @override
  List<Object> get props => [voucherId];
}

@immutable
class VoucherRedeem extends VoucherEvent {
  final String voucherId;
  final String qrCode;
  final String pin;

  VoucherRedeem({
    required this.voucherId,
    required this.qrCode,
    required this.pin,
  });

  @override
  List<Object> get props => [voucherId, qrCode, pin];
}

@immutable
class VoucherRating extends VoucherEvent {
  final String id;
  final int rating;
  final String comment;

  VoucherRating({
    required this.id,
    required this.rating,
    required this.comment,
  });

  @override
  List<Object> get props => [id, rating, comment];
}

@immutable
class VoucherOutletLocationEnable extends VoucherEvent {}

@immutable
class VoucherOutletLocationDisable extends VoucherEvent {}
