import '../../domain.dart';

// Qrcode profile entity. Will call in user_barcode_entity.dart

class ProfileBarcodeEntity extends Entity<String> {
  final String? membershipId;
  final String? membershipName;
  final String? membershipBG;
  final String? image;
  final String? code;
  final String? name;
  final String? points;
  final String? credits;
  final String? coins;

  const ProfileBarcodeEntity({
    required String id,
    this.membershipId,
    this.membershipName,
    this.membershipBG,
    this.image,
    this.code,
    this.name,
    this.points,
    this.credits,
    this.coins,
  }) : super(id);

  @override
  List<Object?> get props => [
    id,
    membershipId,
    membershipName,
    membershipBG,
    image,
    code,
    name,
    points,
    credits,
    coins,
  ];
}
