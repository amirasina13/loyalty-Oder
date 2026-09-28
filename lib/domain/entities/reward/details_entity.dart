import '../../domain.dart';

// Voucher details entity. Will call in details_data_entity.dart

class DetailsEntity extends Entity<String> {
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

  const DetailsEntity({
    required String id,
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
  }) : super(id);

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
}
