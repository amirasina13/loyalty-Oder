import '../../domain.dart';

// User profile entity

class UserProfileEntity extends Entity<String> {
  final ProfileEntity? profile;

  const UserProfileEntity({required String id, this.profile}) : super(id);

  @override
  List<Object?> get props => [id, profile];
}
