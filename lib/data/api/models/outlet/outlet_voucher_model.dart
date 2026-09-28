import '../../../../domain/domain.dart';

// Outlet voucher list model (will call in outlet_details_model.dart)

class OutletVoucherModel extends OutletVoucherEntity {
  const OutletVoucherModel({
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
    super.aftDisPoints,
    super.aftDisCredits,
    super.aftDisCoins,
    super.purchaseText,
    super.voucherType,
    super.isSoldOut,
  });

  factory OutletVoucherModel.fromJson(Map<String, dynamic> json) {
    return OutletVoucherModel(
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
      muslimCategory: json['muslimCategory'] ?? '',
      faceAmount: json['faceAmount'] ?? '',
      isDiscount: json['isDiscount'] ?? '',
      aftDisPoints: json['aftDisPoints'] ?? '',
      aftDisCredits: json['aftDisCredits'] ?? '',
      aftDisCoins: json['aftDisCoins'] ?? '',
      purchaseText: json['purchaseText'] ?? '',
      voucherType: json['voucherType'] ?? '',
      isSoldOut: json['isSoldOut'] ?? false,
    );
  }
}
