import 'package:equatable/equatable.dart';

import '../../../domain/domain.dart';
import '../../data.dart';

/* 
  Equatable overrides == and hashCode for you so you don't have to waste your time writing lots of boilerplate code. 
  With Equatable there is no code generation needed.
  
  CLASS FOR PAST VOUCHER LIST
*/

class VoucherPast extends Equatable {
  final String? id;
  final String? voucherId;
  final String? code;
  final String? image;
  final String? name;
  final String? desc;
  final bool? isUsed;
  final String? usedAt;
  final bool? isExpired;
  final String? expiredAt;
  final int? rating;
  final String? comment;

  const VoucherPast({
    this.id,
    this.voucherId,
    this.code,
    this.image,
    this.name,
    this.desc,
    this.isUsed,
    this.usedAt,
    this.isExpired,
    this.expiredAt,
    this.rating,
    this.comment,
  });

  @override
  List<Object?> get props => [
    id,
    voucherId,
    code,
    image,
    name,
    desc,
    isUsed,
    usedAt,
    isExpired,
    expiredAt,
    rating,
    comment,
  ];

  @override
  factory VoucherPast.fromEntity(Entity entity) {
    if (entity is VoucherPastEntity) {
      return VoucherPast(
        id: entity.id,
        voucherId: entity.voucherId,
        code: entity.code,
        image: entity.image,
        name: entity.name,
        desc: entity.desc,
        isUsed: entity.isUsed,
        usedAt: entity.usedAt,
        isExpired: entity.isExpired,
        expiredAt: entity.expiredAt,
        rating: entity.rating,
        comment: entity.comment,
      );
    } else {
      throw EntityModelMapperException(
        message: 'Entity should be of type VoucherEntity',
      );
    }
  }
}
