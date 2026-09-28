// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

@immutable
abstract class SplashState {}

@immutable
class SplashInitial extends SplashState {}

@immutable
class SplashLoading extends SplashState {}

@immutable
class SplashLoaded extends SplashState {}

@immutable
class SplashLocationRequested extends SplashState {}

@immutable
class SplashLocationDisabled extends SplashState {}

// @immutable
// class SplashDynamic extends SplashState {
//   final PendingDynamicLinkData refferalCode;

//   SplashDynamic({required this.refferalCode});

//   List<Object> get props => [refferalCode];
// }

@immutable
class SplashNetworkError extends SplashState {
  final String error;

  SplashNetworkError({required this.error});

  List<Object> get props => [error];
}
