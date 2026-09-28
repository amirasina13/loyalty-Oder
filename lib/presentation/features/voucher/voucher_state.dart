import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../data/data.dart';

@immutable
abstract class VoucherState extends Equatable {
  @override
  List<Object> get props => [];
}

@immutable
class VoucherInitial extends VoucherState {}

@immutable
class VoucherLoading extends VoucherState {}

@immutable
class VoucherReload extends VoucherState {}

@immutable
class VoucherOutletLocationRequested extends VoucherState {}

@immutable
class VoucherOutletLocationDisabled extends VoucherState {}

@immutable
class VoucherOutletStarted extends VoucherState {}

@immutable
class VoucherListLoaded extends VoucherState {
  final List<Voucher> vouchers;

  VoucherListLoaded({required this.vouchers});

  @override
  List<Object> get props => [vouchers];

  @override
  String toString() => '${vouchers.length} Voucher List Loaded';
}

@immutable
class VoucherCategoriesLoaded extends VoucherState {
  final VoucherData vouchers;

  VoucherCategoriesLoaded({required this.vouchers});

  @override
  List<Object> get props => [vouchers];

  @override
  String toString() => 'Voucher List Loaded';
}

@immutable
class VoucherCountLoaded extends VoucherState {
  final int vouchersLength;

  VoucherCountLoaded({required this.vouchersLength});

  @override
  List<Object> get props => [vouchersLength];

  @override
  String toString() => 'Voucher Count Loaded';
}

@immutable
class VoucherPastTransactionsLoaded extends VoucherState {
  final List<VoucherPast> vouchersPast;

  VoucherPastTransactionsLoaded({required this.vouchersPast});

  @override
  List<Object> get props => [vouchersPast];

  @override
  String toString() => '${vouchersPast.length} Voucher Past List Loaded';
}

@immutable
class VoucherEmpty extends VoucherState {}

@immutable
class VoucherDetailsEmpty extends VoucherState {}

@immutable
class VoucherQrEmpty extends VoucherState {}

@immutable
class VoucherDetailsLoading extends VoucherState {}

@immutable
class VoucherPastDetailsLoading extends VoucherState {}

@immutable
class VoucherQrLoading extends VoucherState {}

@immutable
class VoucherDetailsLoaded extends VoucherState {
  final VoucherDetails details;

  VoucherDetailsLoaded({required this.details});

  @override
  List<Object> get props => [details];

  @override
  String toString() => 'Voucher Details Loaded';
}

@immutable
class VoucherPastDetailsLoaded extends VoucherState {
  final VoucherPastDetails pastDetails;

  VoucherPastDetailsLoaded({required this.pastDetails});

  @override
  List<Object> get props => [pastDetails];

  @override
  String toString() => 'Voucher Past Details Loaded';
}

@immutable
class VoucherQrLoaded extends VoucherState {
  final VoucherDetails details;

  VoucherQrLoaded({required this.details});

  @override
  List<Object> get props => [details];

  @override
  String toString() => 'Voucher Qr Loaded';
}

@immutable
class VoucherRedeemSuccess extends VoucherState {
  final dynamic redeemResponse;

  VoucherRedeemSuccess({required this.redeemResponse});

  @override
  List<Object> get props => [redeemResponse];

  @override
  String toString() => 'Redeem Vouchers Success';
}

@immutable
class VoucherRedeemFailed extends VoucherState {
  final dynamic redeemResponse;

  VoucherRedeemFailed({required this.redeemResponse});

  @override
  List<Object> get props => [redeemResponse];

  @override
  String toString() => 'Redeem Vouchers Failed';
}

@immutable
class VoucherRatingSuccess extends VoucherState {
  final dynamic ratingResponse;

  VoucherRatingSuccess({required this.ratingResponse});

  @override
  List<Object> get props => [ratingResponse];

  @override
  String toString() => 'Rating Vouchers Success';
}

@immutable
class VoucherRatingFailed extends VoucherState {
  final dynamic ratingResponse;

  VoucherRatingFailed({required this.ratingResponse});

  @override
  List<Object> get props => [ratingResponse];

  @override
  String toString() => 'Rating Vouchers Failed';
}

@immutable
class VoucherError extends VoucherState {
  final String error;

  VoucherError({required this.error});

  @override
  List<Object> get props => [error];
}

@immutable
class VoucherNetworkError extends VoucherState {
  final String error;

  VoucherNetworkError({required this.error});

  @override
  List<Object> get props => [error];
}

@immutable
class VoucherSessionError extends VoucherState {
  final String error;

  VoucherSessionError({required this.error});

  @override
  List<Object> get props => [error];
}

@immutable
class VoucherMaintenanceError extends VoucherState {
  final String message;

  VoucherMaintenanceError({required this.message});

  @override
  List<Object> get props => [message];
}
