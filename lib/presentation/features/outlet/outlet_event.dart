import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class OutletEvent extends Equatable {
  @override
  List<Object> get props => [];
}

@immutable
class OutletCheck extends OutletEvent {}

@immutable
class NearOutletLoad extends OutletEvent {}

@immutable
class OutletAllLoad extends OutletEvent {}

@immutable
class MerchantOutletLoad extends OutletEvent {
  final String merchantId;

  MerchantOutletLoad({required this.merchantId});

  @override
  List<Object> get props => [merchantId];
}

@immutable
class MerchantLoad extends OutletEvent {}

@immutable
class OutletLoad extends OutletEvent {}

@immutable
class OutletDetailsLoad extends OutletEvent {
  final String outletId;

  OutletDetailsLoad({required this.outletId});

  @override
  List<Object> get props => [outletId];
}

@immutable
class OutletLocationEnable extends OutletEvent {}

@immutable
class OutletLocationDisable extends OutletEvent {}
