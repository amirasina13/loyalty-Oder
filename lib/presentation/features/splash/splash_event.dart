import 'package:flutter/material.dart';

@immutable
abstract class SplashEvent {}

@immutable
class SplashStart extends SplashEvent {}

@immutable
class SplashLocationEnable extends SplashEvent {}

@immutable
class SplashLocationDisable extends SplashEvent {}
