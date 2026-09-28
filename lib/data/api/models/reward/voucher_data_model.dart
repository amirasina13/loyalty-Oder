import '../../../../domain/domain.dart';

// voucher active list model

class VoucherRewardModel extends VoucherRewardEntity {
  const VoucherRewardModel({
    required super.id,
    super.image,
    super.type,
    super.name,
    super.desc,
    super.purchaseMethod,
    super.points,
    super.credits,
    super.quantity,
    super.isMuslim,
    super.muslimCategory,
    super.faceAmount,
    super.isDiscount,
    super.isTimeLimit,
    super.timeStart,
    super.timeEnd,
    super.aftDisPoints,
    super.aftDisCredits,
    super.aftDisCoins,
    super.purchaseText,
    super.voucherType,
    super.isSoldOut,
    super.isFavourite,
  });

  factory VoucherRewardModel.fromJson(Map<String, dynamic> json) {
    return VoucherRewardModel(
      id: json['id'].toString(),
      image: json['image'] ?? '',
      type: json['type'] ?? '',
      name: json['name'] ?? '',
      desc: json['desc'] ?? '',
      purchaseMethod: json['purchaseMethod'] ?? '',
      points: json['points'],
      credits: json['credits'] ?? '',
      quantity: json['quantity'] ?? '',
      isMuslim: json['isMuslim'] ?? false,
      muslimCategory: json['muslimCategory'] ?? '',
      faceAmount: json['faceAmount'] ?? '',
      isTimeLimit: json['isTimeLimit'] ?? false,
      timeStart: json['timeStart'] ?? '',
      timeEnd: json['timeEnd'] ?? '',
      isDiscount: json['isDiscount'] ?? '',
      aftDisPoints: json['aftDisPoints'] ?? '',
      aftDisCredits: json['aftDisCredits'] ?? '',
      aftDisCoins: json['aftDisCoins'] ?? '',
      purchaseText: json['purchaseText'] ?? '',
      voucherType: json['voucherType'] ?? '',
      isSoldOut: json['isSoldOut'] ?? false,
      isFavourite: json['isFavourite'] ?? false,
    );
  }
}
