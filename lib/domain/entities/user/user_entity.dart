import '../../domain.dart';

// User entity. For login data

class UserEntity extends Entity<String> {
  final String? email;
  final String? contact;
  final String? password;
  final String? access;
  final String? pushToken;
  final bool? isRemember;

  const UserEntity({
    required String id,
    this.email,
    this.contact,
    this.password,
    this.access = 'mobile',
    this.pushToken,
    this.isRemember = true,
  }) : super(id);

  @override
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'contact': contact,
      'password': password,
      'access': access,
      'pushToken': pushToken,
      'isRemember': isRemember,
    };
  }

  @override
  List<Object?> get props => [id, email, password, pushToken];
}
