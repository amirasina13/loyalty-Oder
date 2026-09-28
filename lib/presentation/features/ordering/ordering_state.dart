import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../data/data.dart';

@immutable
abstract class OrderingState extends Equatable {
  @override
  List<Object> get props => [];
}

@immutable
class OrderingInitial extends OrderingState {}

@immutable
class OrderingLoading extends OrderingState {}

@immutable
class BrandsLoading extends OrderingState {}

@immutable
class OrderingOutletLoading extends OrderingState {}

@immutable
class OrderingStarted extends OrderingState {}

@immutable
class OrderingLocationRequested extends OrderingState {}

@immutable
class OrderingEnableStarted extends OrderingState {}

@immutable
class BrandsLoaded extends OrderingState {
  final List<MerchantList> merchants;

  BrandsLoaded({required this.merchants});

  @override
  List<Object> get props => [merchants];

  @override
  String toString() => '${merchants.length} Merchant List Loaded';
}

@immutable
class OutletAddRemoveFavouriteLoaded extends OrderingState {
  final String outletId;
  final String merchantId;
  final bool isFavourite;

  OutletAddRemoveFavouriteLoaded({
    required this.outletId,
    required this.isFavourite,
    required this.merchantId,
  });

  @override
  List<Object> get props => [outletId, merchantId, isFavourite];
}

@immutable
class OrderingEmpty extends OrderingState {}

@immutable
class NearbyEmpty extends OrderingState {}

@immutable
class MerchantEmpty extends OrderingState {}

@immutable
class OutletsLoaded extends OrderingState {
  final OutletInfo outlets;

  OutletsLoaded({required this.outlets});

  @override
  List<Object> get props => [outlets];

  @override
  String toString() => 'Outlet Info Loaded';
}

@immutable
class MerchantBookmarkLoaded extends OrderingState {
  final List<MerchantBookmark> merchantBookmark;

  MerchantBookmarkLoaded({required this.merchantBookmark});

  @override
  List<Object> get props => [merchantBookmark];

  @override
  String toString() => '${merchantBookmark.length} Favourite List Loaded';
}

// @immutable
// class OutletMerchantLoaded extends OrderingState {
//   final List<OutletFav> outletFavourite;

//   OutletMerchantLoaded({required this.outletFavourite});

//   @override
//   List<Object> get props => [
//         outletFavourite,
//       ];

//   @override
//   String toString() => '${outletFavourite.length} Favourite List Loaded';
// }

@immutable
class NearbyNextLoading extends OrderingState {}

@immutable
class MerchantNextLoading extends OrderingState {}

@immutable
class NearbyListStop extends OrderingState {}

@immutable
class NearbySearchStop extends OrderingState {}

@immutable
class PageReload extends OrderingState {}

@immutable
class NearbyLoaded extends OrderingState {
  final NearbyOutlet outlets;

  NearbyLoaded({required this.outlets});

  @override
  List<Object> get props => [outlets];

  @override
  String toString() => '${outlets.outlets!.length} Nearby outlet List Loaded';
}

@immutable
class FavouriteAddRemove extends OrderingState {
  final Map favOutlet;

  FavouriteAddRemove({required this.favOutlet});

  @override
  List<Object> get props => [favOutlet];

  @override
  String toString() => 'Add Remove Loaded';
}

@immutable
class FavOutletListLoaded extends OrderingState {
  final List<OutletFavourite> outletListFav;

  FavOutletListLoaded({required this.outletListFav});

  @override
  List<Object> get props => [outletListFav];

  @override
  String toString() => '${outletListFav.length} Outlet Favourite List Loaded';
}

@immutable
class OrderingError extends OrderingState {
  final String error;

  OrderingError({required this.error});

  @override
  List<Object> get props => [error];
}

@immutable
class OrderingNetworkError extends OrderingState {
  final String error;

  OrderingNetworkError({required this.error});

  @override
  List<Object> get props => [error];
}

@immutable
class OrderingSessionError extends OrderingState {
  final String error;

  OrderingSessionError({required this.error});

  @override
  List<Object> get props => [error];
}

@immutable
class OrderingMaintenanceError extends OrderingState {
  final String message;

  OrderingMaintenanceError({required this.message});

  @override
  List<Object> get props => [message];
}

@immutable
class OrderingLocationDisabled extends OrderingState {}
