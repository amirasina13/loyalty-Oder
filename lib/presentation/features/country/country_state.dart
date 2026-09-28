import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../data/data.dart';

/* States represent the information to be processed by any widget. A widget changes itself based on the state. */
/* States are simply the application’s state, which can be changed in response to the event received. */

// List state for country
@immutable
abstract class CountryState extends Equatable {
  @override
  List<Object> get props => [];
}

@immutable
class CountryInitial extends CountryState {}

@immutable
class CountryLoaded extends CountryState {}

@immutable
class CountryListLoaded extends CountryState {
  final List<Country> countries;

  CountryListLoaded({required this.countries});

  @override
  String toString() => 'CountryListLoaded';

  @override
  List<Object> get props => [countries];
}

@immutable
class CountryError extends CountryState {
  final String error;

  CountryError({required this.error});

  @override
  List<Object> get props => [error];
}

@immutable
class CountryNetworkError extends CountryState {
  final String error;

  CountryNetworkError({required this.error});

  @override
  List<Object> get props => [error];
}
