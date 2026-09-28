import 'package:equatable/equatable.dart';

import '../../../domain/domain.dart';
import '../../data.dart';

/* 
  Equatable overrides == and hashCode for you so you don't have to waste your time writing lots of boilerplate code. 
  With Equatable there is no code generation needed.
  
  CLASS FOR VOUCHER DETAILS
*/

class VoucherDetails extends Equatable {
  final String? id;
  final String? voucherId;
  final String? image;
  final String? type;
  final String? name;
  final String? desc;
  final String? code;
  final String? expired;
  final bool? isMuslim;
  final String? muslimCategory;
  final String? purchaseMethod;
  final String? redeemMethod;
  final String? tnc;
  final String? voucherType;
  final String? share;
  final String? shareLink;
  final String? qr;
  final String? barcode;
  final List<RewardOutlet>? outlets;

  const VoucherDetails({
    this.id,
    this.voucherId,
    this.image,
    this.type,
    this.name,
    this.desc,
    this.code,
    this.expired,
    this.isMuslim,
    this.muslimCategory,
    this.purchaseMethod,
    this.redeemMethod,
    this.tnc,
    this.voucherType,
    this.share,
    this.shareLink,
    this.qr,
    this.barcode,
    this.outlets,
  });

  @override
  List<Object?> get props => [
    id,
    voucherId,
    image,
    type,
    name,
    desc,
    code,
    expired,
    isMuslim,
    muslimCategory,
    purchaseMethod,
    redeemMethod,
    tnc,
    voucherType,
    share,
    shareLink,
    qr,
    barcode,
    outlets,
  ];

  @override
  factory VoucherDetails.fromEntity(Entity entity) {
    if (entity is VoucherDetailsEntity) {
      List<RewardOutlet> outlets = [];
      entity.outlets?.forEach((s) {
        outlets.add(RewardOutlet.fromEntity(s));
      });

      return VoucherDetails(
        id: entity.id,
        voucherId: entity.voucherId,
        image: entity.image,
        type: entity.type,
        name: entity.name,
        desc: entity.desc,
        code: entity.code,
        expired: entity.expired,
        isMuslim: entity.isMuslim,
        muslimCategory: entity.muslimCategory,
        purchaseMethod: entity.purchaseMethod,
        redeemMethod: entity.redeemMethod,
        tnc: entity.tnc,
        voucherType: entity.voucherType,
        share: entity.share,
        shareLink: entity.shareLink,
        qr: entity.qr,
        barcode: entity.barcode,
        outlets: outlets,
      );
    } else {
      throw EntityModelMapperException(
        message: 'Entity should be of type VoucherDetailsEntity',
      );
    }
  }
}
