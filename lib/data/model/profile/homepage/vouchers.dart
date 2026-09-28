import 'package:equatable/equatable.dart';

import '../../../../domain/domain.dart';
import '../../../data.dart';

/* 
  Equatable overrides == and hashCode for you so you don't have to waste your time writing lots of boilerplate code. 
  With Equatable there is no code generation needed.
  
  CLASS FOR VOUCHER IN HOMEPAGE. WILL CALL IN HOME_PAGE.DART
*/

class VouchersCat extends Equatable {
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
  final bool? isTimeLimit;
  final String? timeStart;
  final String? timeEnd;
  final bool? isDiscount;
  final String? aftDisPoints;
  final String? aftDisCredits;
  final String? purchaseText;
  final String? voucherType;
  final bool? isSoldOut;

  const VouchersCat({
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
    this.isTimeLimit,
    this.timeStart,
    this.timeEnd,
    this.isDiscount,
    this.aftDisPoints,
    this.aftDisCredits,
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
    isTimeLimit,
    timeStart,
    timeEnd,
    isDiscount,
    aftDisPoints,
    aftDisCredits,
    purchaseText,
    voucherType,
    isSoldOut,
  ];

  @override
  factory VouchersCat.fromEntity(Entity entity) {
    if (entity is VouchersCatEntity) {
      return VouchersCat(
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
        isTimeLimit: entity.isTimeLimit,
        timeStart: entity.timeStart,
        timeEnd: entity.timeEnd,
        isDiscount: entity.isDiscount,
        aftDisPoints: entity.aftDisPoints,
        aftDisCredits: entity.aftDisCredits,
        purchaseText: entity.purchaseText,
        voucherType: entity.voucherType,
        isSoldOut: entity.isSoldOut,
      );
    } else {
      throw EntityModelMapperException(
        message: 'Entity should be of type VouchersCatEntity',
      );
    }
  }
}
