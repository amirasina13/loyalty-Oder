import 'package:equatable/equatable.dart';

import '../../../domain/domain.dart';
import '../../data.dart';

/* 
  Equatable overrides == and hashCode for you so you don't have to waste your time writing lots of boilerplate code. 
  With Equatable there is no code generation needed.
  
  CLASS FOR USER 
*/

class UserProfile extends Equatable {
  final Profile? profile;

  const UserProfile({this.profile});

  @override
  List<Object?> get props => [profile];

  @override
  factory UserProfile.fromEntity(Entity entity) {
    if (entity is UserProfileEntity) {
      return UserProfile(profile: Profile.fromEntity(entity.profile!));
    } else {
      throw EntityModelMapperException(
        message: 'Entity should be of type UserProfileEntity',
      );
    }
  }
}
