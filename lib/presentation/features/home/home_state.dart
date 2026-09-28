import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../data/data.dart';

@immutable
abstract class HomeState extends Equatable {
  @override
  List<Object> get props => [];
}

@immutable
class HomeInitial extends HomeState {
  @override
  String toString() => 'HomeInitial';
}

@immutable
class HomeProcessing extends HomeState {}

@immutable
class HomeLoaded extends HomeState {
  final String? token;
  final HomePage homePage;

  HomeLoaded({this.token, required this.homePage});

  @override
  String toString() => 'HomeLoaded';
}

@immutable
class SearchClearLoaded extends HomeState {
  @override
  String toString() => 'SearchClearLoaded';
}

@immutable
class SearchEmpty extends HomeState {
  @override
  String toString() => 'SearchEmpty';
}

@immutable
class HomeNetworkError extends HomeState {
  final String error;

  HomeNetworkError(this.error);

  @override
  List<Object> get props => [error];
}

@immutable
class HomeError extends HomeState {
  final String error;

  HomeError({required this.error});

  @override
  List<Object> get props => [error];
}

@immutable
class HomeSessionError extends HomeState {
  final String error;

  HomeSessionError({required this.error});

  @override
  List<Object> get props => [error];
}

@immutable
class HomeMaintenanceError extends HomeState {
  final String message;

  HomeMaintenanceError({required this.message});

  @override
  List<Object> get props => [message];
}

@immutable
class VoucherBrandLoaded extends HomeState {
  final List<dynamic>? searchData;

  VoucherBrandLoaded({this.searchData});

  @override
  String toString() => 'VoucherBrandLoaded';
}

@immutable
class SearchLoaded extends HomeState {
  final List<dynamic>? searchData;

  SearchLoaded({this.searchData});

  @override
  String toString() => 'SearchLoaded';
}
