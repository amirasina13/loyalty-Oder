import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class PhotoEvent extends Equatable {
  @override
  List<Object> get props => [];
}

@immutable
class PhotoStart extends PhotoEvent {}

@immutable
class GetPhoto extends PhotoEvent {
  final File photo;

  GetPhoto({required this.photo});

  @override
  List<Object> get props => [photo];
}

@immutable
class PhotoFailure extends PhotoEvent {}
