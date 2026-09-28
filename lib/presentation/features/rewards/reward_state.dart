import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../data/data.dart';

@immutable
abstract class RewardState extends Equatable {
  @override
  List<Object> get props => [];
}

@immutable
class RewardInitial extends RewardState {}

@immutable
class RewardLoading extends RewardState {}

@immutable
class RewardRefresh extends RewardState {}

@immutable
class RewardNextLoading extends RewardState {}

@immutable
class RewardListStop extends RewardState {}

@immutable
class FavClick extends RewardState {
  // final bool isFavourite;

  // FavClick({required this.isFavourite});

  // @override
  // List<Object> get props => [isFavourite];
}

@immutable
class RewardAddRemoveFavouriteLoaded extends RewardState {
  final String voucherId;
  final bool isFavourite;

  RewardAddRemoveFavouriteLoaded({
    required this.voucherId,
    required this.isFavourite,
  });

  @override
  List<Object> get props => [voucherId, isFavourite];
}

@immutable
class FilterCategoryLoaded extends RewardState {
  final FilterData filterData;

  FilterCategoryLoaded({required this.filterData});

  @override
  List<Object> get props => [filterData];

  @override
  String toString() => 'Filter Category Loaded';
}

@immutable
class RewardListLoaded extends RewardState {
  final RewardData voucherRewards;
  final bool hasMore;

  RewardListLoaded({required this.voucherRewards, this.hasMore = true});

  @override
  List<Object> get props => [voucherRewards, hasMore];

  @override
  String toString() => 'Transaction Reward Loaded';
}

@immutable
class RewardFilterListLoaded extends RewardState {
  final RewardData voucherRewards;

  RewardFilterListLoaded({required this.voucherRewards});

  @override
  List<Object> get props => [voucherRewards];

  @override
  String toString() => 'Filter Reward Loaded';
}

@immutable
class RewardFilterEmpty extends RewardState {
  final List voucherRewards;

  RewardFilterEmpty({required this.voucherRewards});

  @override
  List<Object> get props => [voucherRewards];

  @override
  String toString() => 'Filter Reward Empty';
}

@immutable
class RewardMerchantLoaded extends RewardState {
  final List<RewardMerchant> rewards;

  RewardMerchantLoaded({required this.rewards});

  @override
  List<Object> get props => [rewards];

  @override
  String toString() => 'Transaction Reward Loaded';
}

@immutable
class RewardEmpty extends RewardState {}

@immutable
class RewardDetailsEmpty extends RewardState {}

@immutable
class RewardOutletDetailsEmpty extends RewardState {}

@immutable
class RewardDetailsLoading extends RewardState {}

@immutable
class RewardOutletDetailsLoading extends RewardState {}

@immutable
class RewardDownloadSuccess extends RewardState {
  final Map data;

  RewardDownloadSuccess({required this.data});

  @override
  List<Object> get props => [data];

  @override
  String toString() => 'Download Successful';
}

@immutable
class RewardPurchaseSuccess extends RewardState {
  final Map data;

  RewardPurchaseSuccess({required this.data});

  @override
  List<Object> get props => [data];

  @override
  String toString() => 'Purchase Successful';
}

@immutable
class RewardDetailsLoaded extends RewardState {
  final DetailsData details;

  RewardDetailsLoaded({required this.details});

  @override
  List<Object> get props => [details];

  @override
  String toString() => 'Transaction Details Loaded';
}

@immutable
class RewardDetailsDynamicLoaded extends RewardState {
  final DetailsData details;

  RewardDetailsDynamicLoaded({required this.details});

  @override
  List<Object> get props => [details];

  @override
  String toString() => 'Transaction Details Dynamic Loaded';
}

@immutable
class RewardRedeemSuccess extends RewardState {
  final dynamic redeemResponse;

  RewardRedeemSuccess({required this.redeemResponse});

  @override
  List<Object> get props => [redeemResponse];

  @override
  String toString() => 'Redeem Rewards Success';
}

@immutable
class RewardRedeemFailed extends RewardState {
  final dynamic redeemResponse;

  RewardRedeemFailed({required this.redeemResponse});

  @override
  List<Object> get props => [redeemResponse];

  @override
  String toString() => 'Redeem Rewards Failed';
}

@immutable
class RewardFavouriteLoaded extends RewardState {
  final List<RewardFavourite> rewardFavourite;

  RewardFavouriteLoaded({required this.rewardFavourite});

  @override
  List<Object> get props => [rewardFavourite];

  @override
  String toString() => '${rewardFavourite.length} Favourite List Loaded';
}

@immutable
class RewardOutletLocationRequested extends RewardState {}

@immutable
class RewardOutletLocationDisabled extends RewardState {}

@immutable
class RewardOutletStarted extends RewardState {}

@immutable
class RewardOutletLoaded extends RewardState {
  final List<RewardOutlet> rewardOutlet;

  RewardOutletLoaded({required this.rewardOutlet});

  @override
  List<Object> get props => [rewardOutlet];

  @override
  String toString() => 'List Outlet Loaded';
}

@immutable
class RewardOutletDetailsLoaded extends RewardState {
  final OutletDetails details;

  RewardOutletDetailsLoaded({required this.details});

  @override
  List<Object> get props => [details];

  @override
  String toString() => 'Transaction Outlet Details Loaded';
}

@immutable
class RewardError extends RewardState {
  final String error;

  RewardError({required this.error});

  @override
  List<Object> get props => [error];
}

@immutable
class RewardNetworkError extends RewardState {
  final String error;

  RewardNetworkError({required this.error});

  @override
  List<Object> get props => [error];
}

@immutable
class RewardSessionError extends RewardState {
  final String error;

  RewardSessionError({required this.error});

  @override
  List<Object> get props => [error];
}

@immutable
class RewardMaintenanceError extends RewardState {
  final String message;

  RewardMaintenanceError({required this.message});

  @override
  List<Object> get props => [message];
}
