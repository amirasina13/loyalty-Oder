import 'package:equatable/equatable.dart';

import '../../../domain/domain.dart';
import '../../data.dart';

/* 
  Equatable overrides == and hashCode for you so you don't have to waste your time writing lots of boilerplate code. 
  With Equatable there is no code generation needed.
  
  CLASS FOR USER REFERRAL CODE DETAILS
*/

class UserRefer extends Equatable {
  final String? code;
  final String? link;
  final String? qr;
  final String? barcode;
  final String? codeString;
  final String? text;

  const UserRefer({
    this.code,
    this.link,
    this.qr,
    this.barcode,
    this.codeString,
    this.text,
  });

  @override
  List<Object?> get props => [code, link, qr, barcode, codeString, text];

  @override
  factory UserRefer.fromEntity(Entity entity) {
    if (entity is UserReferEntity) {
      return UserRefer(
        code: entity.code,
        link: entity.link,
        qr: entity.qr,
        barcode: entity.barcode,
        codeString: entity.codeString,
        text: entity.text,
      );
    } else {
      throw EntityModelMapperException(
        message: 'Entity should be of type UserReferEntity',
      );
    }
  }
}
