import 'package:equatable/equatable.dart';

import '../../../domain/domain.dart';
import '../../data.dart';

/* 
  Equatable overrides == and hashCode for you so you don't have to waste your time writing lots of boilerplate code. 
  With Equatable there is no code generation needed.
  
  CLASS FOR USER QRCODE (CARD PART)
*/

class UserQrcode extends Equatable {
  final ProfileQrcode? profile;
  final String? qr;
  final String? barcode;
  final String? codeString;

  const UserQrcode({this.profile, this.qr, this.barcode, this.codeString});

  @override
  List<Object?> get props => [profile, qr, barcode, codeString];

  @override
  factory UserQrcode.fromEntity(Entity entity) {
    if (entity is UserQrcodeEntity) {
      return UserQrcode(
        profile: ProfileQrcode.fromEntity(entity.profile!),
        qr: entity.qr,
        barcode: entity.barcode,
        codeString: entity.codeString,
      );
    } else {
      throw EntityModelMapperException(
        message: 'Entity should be of type UserQrcodeEntity',
      );
    }
  }
}
