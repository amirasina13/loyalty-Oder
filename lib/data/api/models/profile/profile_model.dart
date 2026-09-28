import '../../../../domain/domain.dart';

// Profile model (will call in user_profile_model.dart)

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.id,
    super.membershipId,
    super.membershipName,
    super.membershipBG,
    super.image,
    super.code,
    super.name,
    super.surname,
    super.forename,
    super.dob,
    super.gender,
    super.contact,
    super.cCode,
    super.cValid,
    super.email,
    super.eValid,
    super.points,
    super.credits,
    super.coins,
    super.isMuslim,
    super.isMuslimUpdate,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'].toString(),
      membershipId: json['membershipId'].toString(),
      membershipName: json['membershipName'] ?? '',
      membershipBG: json['membershipBG'] ?? '',
      image: json['image'] ?? '',
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      surname: json['surname'] ?? '',
      forename: json['forename'] ?? '',
      dob: json['dob'] ?? '',
      gender: json['gender'] ?? '',
      contact: json['contact'] ?? '',
      cCode: json['cCode'] ?? '',
      cValid: json['cValid'],
      email: json['email'] ?? '',
      eValid: json['eValid'],
      points: json['points'] ?? '',
      credits: json['credits'] ?? '',
      coins: json['coins'] ?? '',
      isMuslim: json['isMuslim'] ?? '',
      isMuslimUpdate: json['isMuslimUpdate'] ?? '',
    );
  }
}
