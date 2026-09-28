import 'package:equatable/equatable.dart';

import '../../../domain/domain.dart';
import '../../data.dart';

/* 
  Equatable overrides == and hashCode for you so you don't have to waste your time writing lots of boilerplate code. 
  With Equatable there is no code generation needed.
  
  CLASS FOR IF PERKS DETAILS VOUCHER. WILL CALL IN DETAILS_DATA.DART
*/

class Details extends Equatable {
  final String? id;
  final String? image;
  final String? type;
  final String? name;
  final String? desc;
  final String? code;
  final int? redeem;
  final String? frequency;
  final int? quantity;
  final int? period;
  final String? start;
  final String? end;
  final bool? isMuslim;
  final String? muslimCategory;
  final String? points;
  final String? credits;
  final String? purchaseMethod;
  final String? convertRate;
  final String? faceAmount;
  final bool? isFavourite;
  final bool? isDiscount;
  final String? aftDisPoints;
  final String? aftDisCredits;
  final String? aftDisCoins;
  final String? tnc;
  final String? purchaseText;
  final String? voucherType;
  final bool? isSoldOut;
  final String? totalRedeemed;
  final String? totalOwned;
  final bool? isAbleRedeem;
  final String? share;
  final String? shareLink;
  final String? videoPath;
  final bool? isVideo;

  const Details({
    this.id,
    this.image,
    this.type,
    this.name,
    this.desc,
    this.code,
    this.redeem,
    this.frequency,
    this.quantity,
    this.period,
    this.start,
    this.end,
    this.isMuslim,
    this.muslimCategory,
    this.points,
    this.credits,
    this.purchaseMethod,
    this.convertRate,
    this.faceAmount,
    this.isFavourite,
    this.isDiscount,
    this.aftDisPoints,
    this.aftDisCredits,
    this.aftDisCoins,
    this.tnc,
    this.purchaseText,
    this.voucherType,
    this.isSoldOut,
    this.totalRedeemed,
    this.totalOwned,
    this.isAbleRedeem,
    this.share,
    this.shareLink,
    this.videoPath,
    this.isVideo,
  });

  @override
  List<Object?> get props => [
    id,
    image,
    type,
    name,
    desc,
    code,
    redeem,
    frequency,
    quantity,
    period,
    start,
    end,
    isMuslim,
    muslimCategory,
    points,
    credits,
    purchaseMethod,
    convertRate,
    faceAmount,
    isFavourite,
    isDiscount,
    aftDisPoints,
    aftDisCredits,
    aftDisCoins,
    tnc,
    purchaseText,
    voucherType,
    isSoldOut,
    totalRedeemed,
    totalOwned,
    isAbleRedeem,
    share,
    shareLink,
    videoPath,
    isVideo,
  ];

  @override
  factory Details.fromEntity(Entity entity) {
    if (entity is DetailsEntity) {
      return Details(
        id: entity.id,
        image: entity.image,
        type: entity.type,
        name: entity.name,
        desc: entity.desc,
        code: entity.code,
        redeem: entity.redeem,
        frequency: entity.frequency,
        quantity: entity.quantity,
        period: entity.period,
        start: entity.start,
        end: entity.end,
        isMuslim: entity.isMuslim,
        muslimCategory: entity.muslimCategory,
        points: entity.points,
        credits: entity.credits,
        purchaseMethod: entity.purchaseMethod,
        convertRate: entity.convertRate,
        faceAmount: entity.faceAmount,
        isFavourite: entity.isFavourite,
        isDiscount: entity.isDiscount,
        aftDisPoints: entity.aftDisPoints,
        aftDisCredits: entity.aftDisCredits,
        aftDisCoins: entity.aftDisCoins,
        tnc: entity.tnc,
        purchaseText: entity.purchaseText,
        voucherType: entity.voucherType,
        isSoldOut: entity.isSoldOut,
        totalRedeemed: entity.totalRedeemed,
        totalOwned: entity.totalOwned,
        isAbleRedeem: entity.isAbleRedeem,
        share: entity.share,
        shareLink: entity.shareLink,
        videoPath: entity.videoPath,
        isVideo: entity.isVideo,
      );
    } else {
      throw EntityModelMapperException(
        message: 'Entity should be of type DetailsEntity',
      );
    }
  }
}
