import 'package:equatable/equatable.dart';

import '../../../domain/domain.dart';
import '../../data.dart';

/* 
  Equatable overrides == and hashCode for you so you don't have to waste your time writing lots of boilerplate code. 
  With Equatable there is no code generation needed.
  
  CLASS FOR VOUCHER OUTLET (WILL CALL IN OUTLET_DETAILS.DART)
*/

class VoucherOutlet extends Equatable {
  final String? id;
  final String? image;
  final String? type;
  final String? name;
  final String? desc;
  final String? purchaseMethod;
  final String? points;
  final String? credits;
  final String? quantity;
  final bool? isMuslim;
  final String? muslimCategory;
  final String? faceAmount;
  final bool? isDiscount;
  final String? aftDisPoints;
  final String? aftDisCredits;
  final String? aftDisCoins;
  final String? purchaseText;
  final String? voucherType;
  final bool? isSoldOut;

  const VoucherOutlet({
    this.id,
    this.image,
    this.type,
    this.name,
    this.desc,
    this.purchaseMethod,
    this.points,
    this.credits,
    this.quantity,
    this.isMuslim,
    this.muslimCategory,
    this.faceAmount,
    this.isDiscount,
    this.aftDisPoints,
    this.aftDisCredits,
    this.aftDisCoins,
    this.purchaseText,
    this.voucherType,
    this.isSoldOut,
  });

  @override
  List<Object?> get props => [
    id,
    image,
    type,
    name,
    desc,
    purchaseMethod,
    points,
    credits,
    quantity,
    isMuslim,
    muslimCategory,
    faceAmount,
    isDiscount,
    aftDisPoints,
    aftDisCredits,
    aftDisCoins,
    purchaseText,
    voucherType,
    isSoldOut,
  ];

  @override
  factory VoucherOutlet.fromEntity(Entity entity) {
    if (entity is OutletVoucherEntity) {
      return VoucherOutlet(
        id: entity.id,
        image: entity.image,
        type: entity.type,
        name: entity.name,
        desc: entity.desc,
        purchaseMethod: entity.purchaseMethod,
        points: entity.points,
        credits: entity.credits,
        quantity: entity.quantity,
        isMuslim: entity.isMuslim,
        muslimCategory: entity.muslimCategory,
        faceAmount: entity.faceAmount,
        isDiscount: entity.isDiscount,
        aftDisPoints: entity.aftDisPoints,
        aftDisCredits: entity.aftDisCredits,
        aftDisCoins: entity.aftDisCoins,
        purchaseText: entity.purchaseText,
        voucherType: entity.voucherType,
        isSoldOut: entity.isSoldOut,
      );
    } else {
      throw EntityModelMapperException(
        message: 'Entity should be of type OperationOutletEntity',
      );
    }
  }
}
