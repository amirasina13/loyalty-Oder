import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class HomeEvent extends Equatable {
  @override
  List<Object> get props => [];
}

@immutable
class HomeStart extends HomeEvent {}

@immutable
class HomeLoad extends HomeEvent {
  @override
  String toString() => 'HomeLoad';
}

@immutable
class SearchClearLoad extends HomeEvent {
  @override
  String toString() => 'SearchClearLoad';
}

@immutable
// ignore: must_be_immutable
class VoucherBrandLoad extends HomeEvent {
  final String? keywords;

  VoucherBrandLoad({this.keywords});

  @override
  List<Object> get props => [];
}

@immutable
// ignore: must_be_immutable
class SearchLoad extends HomeEvent {
  final String? keywords;
  final String? type;

  SearchLoad({this.keywords, this.type});

  @override
  List<Object> get props => [];
}
