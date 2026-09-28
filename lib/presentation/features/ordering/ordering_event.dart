import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class OrderingEvent extends Equatable {
  @override
  List<Object> get props => [];
}

@immutable
class OrderingCheck extends OrderingEvent {}

@immutable
class BrandsLoad extends OrderingEvent {
  final String categoryId;
  final bool loadingFirst;

  BrandsLoad({required this.categoryId, required this.loadingFirst});

  @override
  List<Object> get props => [categoryId, loadingFirst];
}

@immutable
class NearbyLoad extends OrderingEvent {}

@immutable
class NearbySearch extends OrderingEvent {}

// @immutable
// class BrandsCheckingLoad extends OrderingEvent {}

@immutable
class OutletOrderLoad extends OrderingEvent {
  final String brandId;

  OutletOrderLoad({required this.brandId});

  @override
  List<Object> get props => [brandId];
}

@immutable
class MerchantAddRemoveFavouriteLoad extends OrderingEvent {
  final String merchantId;

  MerchantAddRemoveFavouriteLoad({required this.merchantId});

  @override
  List<Object> get props => [merchantId];
}

@immutable
class MerchantBookmarkLoad extends OrderingEvent {}

@immutable
class OutletAddRemoveFavouriteLoad extends OrderingEvent {
  final String outletId;
  final String merchantId;

  OutletAddRemoveFavouriteLoad({
    required this.outletId,
    required this.merchantId,
  });

  @override
  List<Object> get props => [outletId, merchantId];
}

@immutable
class OutletFavListLoad extends OrderingEvent {}

// @immutable
// class OutletMerchantLoad extends OrderingEvent {}

@immutable
class OrderingLocationEnable extends OrderingEvent {}

@immutable
class OrderingLocationDisable extends OrderingEvent {}
