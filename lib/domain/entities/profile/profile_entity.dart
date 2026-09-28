import '../../domain.dart';

// Profile entity. Will call in home_page_entity.dart & user_profile_entity.dart

class ProfileEntity extends Entity<String> {
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

  const ProfileEntity({
    required String id,
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
  }) : super(id);

  @override
  List<Object?> get props => [
    id,
    membershipId,
    membershipName,
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
}
