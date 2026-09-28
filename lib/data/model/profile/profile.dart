import 'package:equatable/equatable.dart';

import '../../../domain/domain.dart';
import '../../data.dart';

/* 
  Equatable overrides == and hashCode for you so you don't have to waste your time writing lots of boilerplate code. 
  With Equatable there is no code generation needed.
  
  CLASS FOR USER PROFILE DETAILS. WILL CALL IN PROFILE.DART
*/

class Profile extends Equatable {
  final String? id;
  final String? membershipId;
  final String? membershipName;
  final String? membershipBG;
  final String? image;
  final String? code;
  final String? name;
  final String? surname;
  final String? forename;
  final String? dob;
  final String? gender;
  final String? contact;
  final String? cCode;
  final bool? cValid;
  final String? email;
  final bool? eValid;
  final String? points;
  final String? credits;
  final String? coins;
  final String? isMuslim;
  final String? isMuslimUpdate;

  const Profile({
    this.id,
    this.membershipId,
    this.membershipName,
    this.membershipBG,
    this.image,
    this.code,
    this.name,
    this.surname,
    this.forename,
    this.dob,
    this.gender,
    this.contact,
    this.cCode,
    this.cValid,
    this.email,
    this.eValid,
    this.points,
    this.credits,
    this.coins,
    this.isMuslim,
    this.isMuslimUpdate,
  });

  @override
  List<Object?> get props => [
    id,
    membershipId,
    membershipName,
    membershipBG,
    image,
    code,
    name,
    surname,
    forename,
    dob,
    gender,
    contact,
    cCode,
    cValid,
    email,
    eValid,
    points,
    credits,
    coins,
    isMuslim,
    isMuslimUpdate,
  ];

  @override
  factory Profile.fromEntity(Entity entity) {
    if (entity is ProfileEntity) {
      return Profile(
        id: entity.id,
        membershipId: entity.membershipId,
        membershipName: entity.membershipName,
        membershipBG: entity.membershipBG,
        image: entity.image,
        code: entity.code,
        name: entity.name,
        surname: entity.surname,
        forename: entity.forename,
        dob: entity.dob,
        gender: entity.gender,
        contact: entity.contact,
        cCode: entity.cCode,
        cValid: entity.cValid,
        email: entity.email,
        eValid: entity.eValid,
        points: entity.points,
        credits: entity.credits,
        coins: entity.coins,
        isMuslim: entity.isMuslim,
        isMuslimUpdate: entity.isMuslimUpdate,
      );
    } else {
      throw EntityModelMapperException(
        message: 'Entity should be of type ProfileEntity',
      );
    }
  }
}
