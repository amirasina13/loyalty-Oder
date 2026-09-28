import 'package:equatable/equatable.dart';

import '../../../domain/domain.dart';
import '../../data.dart';

/* 
  Equatable overrides == and hashCode for you so you don't have to waste your time writing lots of boilerplate code. 
  With Equatable there is no code generation needed.
  
  CLASS FOR VOUCHER PAST/HISTORY DETAILS
*/

class VoucherPastDetails extends Equatable {
  final String? id;
  final String? voucherId;
  final String? code;
  final String? image;
  final String? name;
  final String? desc;
  final bool? isUsed;
  final String? redeemAt;
  final bool? isExpired;
  final String? expiredAt;
  final int? rating;
  final String? comment;

  const VoucherPastDetails({
    this.id,
    this.voucherId,
    this.code,
    this.image,
    this.name,
    this.desc,
    this.isUsed,
    this.redeemAt,
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
    redeemAt,
    isExpired,
    expiredAt,
    rating,
    comment,
  ];

  @override
  factory VoucherPastDetails.fromEntity(Entity entity) {
    if (entity is VoucherPastDetailsEntity) {
      return VoucherPastDetails(
        id: entity.id,
        voucherId: entity.voucherId,
        code: entity.code,
        image: entity.image,
        name: entity.name,
        desc: entity.desc,
        isUsed: entity.isUsed,
        redeemAt: entity.redeemAt,
        isExpired: entity.isExpired,
        expiredAt: entity.expiredAt,
        rating: entity.rating,
        comment: entity.comment,
      );
    } else {
      throw EntityModelMapperException(
        message: 'Entity should be of type VoucherPastDetailsEntity',
      );
    }
  }
}
