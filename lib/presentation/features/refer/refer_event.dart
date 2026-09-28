import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class ReferEvent extends Equatable {
  @override
  List<Object> get props => [];
}

@immutable
class ReferStart extends ReferEvent {}

@immutable
class ReferLoad extends ReferEvent {}
