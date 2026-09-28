import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class PhotoState extends Equatable {
  @override
  List<Object> get props => [];
}

@immutable
class PhotoInitial extends PhotoState {}

@immutable
class PhotoSet extends PhotoState {
  final File photo;

  PhotoSet({required this.photo});

  @override
  List<Object> get props => [photo];
}

@immutable
class PhotoError extends PhotoState {}
