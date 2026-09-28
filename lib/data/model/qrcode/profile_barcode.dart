import 'package:equatable/equatable.dart';

import '../../../domain/domain.dart';
import '../../data.dart';

/* 
  Equatable overrides == and hashCode for you so you don't have to waste your time writing lots of boilerplate code. 
  With Equatable there is no code generation needed.
  
  CLASS FOR USER PROFILE DETAILS (IF CARD PART. WILL CALL IN USER_BARCODE.DART)
*/

class ProfileQrcode extends Equatable {
  final String? id;
  final String? membershipId;
  final String? membershipName;
  final String? membershipBG;
  final String? image;
  final String? code;
  final String? name;
  final String? points;
  final String? credits;
  final String? coins;

  const ProfileQrcode({
    this.id,
    this.membershipId,
    this.membershipName,
    this.membershipBG,
    this.image,
    this.code,
    this.name,
    this.points,
    this.credits,
    this.coins,
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
    points,
    credits,
    coins,
  ];

  @override
  factory ProfileQrcode.fromEntity(Entity entity) {
    if (entity is ProfileBarcodeEntity) {
      return ProfileQrcode(
        id: entity.id,
        membershipId: entity.membershipId,
        membershipName: entity.membershipName,
        membershipBG: entity.membershipBG,
        image: entity.image,
        code: entity.code,
        name: entity.name,
        points: entity.points,
        credits: entity.credits,
        coins: entity.coins,
      );
    } else {
      throw EntityModelMapperException(
        message: 'Entity should be of type ProfileBarcodeEntity',
      );
    }
  }
}
