import '../../../../domain/domain.dart';
import '../../../data.dart';

// User profile data model

class UserProfileModel extends UserProfileEntity {
  const UserProfileModel({required super.id, ProfileModel? super.profile});

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    var profile = ProfileModel.fromJson(json['profile']);

    return UserProfileModel(id: profile.id, profile: profile);
  }
}
