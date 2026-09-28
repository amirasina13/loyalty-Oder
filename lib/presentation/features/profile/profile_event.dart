import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class ProfileEvent extends Equatable {
  @override
  List<Object> get props => [];
}

@immutable
class ProfileStart extends ProfileEvent {}

@immutable
class ProfileLoad extends ProfileEvent {}

@immutable
class ProfileEditLoad extends ProfileEvent {
  final String errorField;

  ProfileEditLoad({required this.errorField});

  @override
  List<Object> get props => [errorField];
}

@immutable
class ProfileRegUpdate extends ProfileEvent {
  final String name;
  final String forename;
  final String surname;
  final String contact;
  final String gender;
  final String dob;
  final bool isMuslim;
  final bool vMuslim;
  final bool? vExtra;
  final bool vProfile;

  ProfileRegUpdate({
    required this.name,
    required this.forename,
    required this.surname,
    required this.contact,
    required this.gender,
    required this.dob,
    required this.isMuslim,
    required this.vMuslim,
    this.vExtra,
    required this.vProfile,
  });

  @override
  List<Object> get props => [
    name,
    forename,
    surname,
    contact,
    gender,
    dob,
    isMuslim,
    vMuslim,
    vProfile,
  ];
}

@immutable
class ProfileUpdate extends ProfileEvent {
  final String name;
  final String forename;
  final String surname;
  final String? email;
  final String dob;
  final String gender;

  ProfileUpdate({
    required this.name,
    required this.forename,
    required this.surname,
    this.email,
    required this.dob,
    required this.gender,
  });

  @override
  List<Object> get props => [name, forename, surname, email ?? '', dob, gender];
}

@immutable
class ProfilePhotoUpdate extends ProfileEvent {
  final String image;

  ProfilePhotoUpdate({required this.image});

  @override
  List<Object> get props => [image];
}

@immutable
class ProfileChangePassword extends ProfileEvent {
  final String password;

  ProfileChangePassword({required this.password});

  @override
  List<Object> get props => [password];
}
