import '../../../../../domain/domain.dart';

// Reward with merchant categories Model

class VouchersCatModel extends VouchersCatEntity {
  const VouchersCatModel({
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
    super.isTimeLimit,
    super.timeStart,
    super.timeEnd,
    super.isDiscount,
    super.aftDisPoints,
    super.aftDisCredits,
    super.purchaseText,
    super.voucherType,
    super.isSoldOut,
  });

  factory VouchersCatModel.fromJson(Map<String, dynamic> json) {
    return VouchersCatModel(
      id: json['id'].toString(),
      image: json['image'] ?? '',
      type: json['type'] ?? '',
      name: json['name'] ?? '',
      desc: json['desc'] ?? '',
      purchaseMethod: json['purchaseMethod'] ?? '',
      points: json['points'] ?? '',
      credits: json['credits'] ?? '',
      quantity: json['quantity'] ?? '',
      isMuslim: json['isMuslim'] ?? false,
      muslimCategory: json['muslimCategory'],
      faceAmount: json['faceAmount'] ?? '',
      isTimeLimit: json['isTimeLimit'] ?? false,
      timeStart: json['timeStart'] ?? '',
      timeEnd: json['timeEnd'] ?? '',
      isDiscount: json['isDiscount'] ?? false,
      aftDisPoints: json['aftDisPoints'] ?? '',
      aftDisCredits: json['aftDisCredits'] ?? '',
      purchaseText: json['purchaseText'] ?? '',
      voucherType: json['voucherType'] ?? '',
      isSoldOut: json['isSoldOut'] ?? false,
    );
  }
}
