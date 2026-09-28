import '../../../../domain/domain.dart';

// Voucher past list model

class VoucherPastDetailsModel extends VoucherPastDetailsEntity {
  const VoucherPastDetailsModel({
    required super.id,
    super.voucherId,
    super.code,
    super.image,
    super.name,
    super.desc,
    super.isUsed,
    super.redeemAt,
    super.isExpired,
    super.expiredAt,
    super.rating,
    super.comment,
  });

  factory VoucherPastDetailsModel.fromJson(Map<String, dynamic> json) {
    return VoucherPastDetailsModel(
      id: json['id'].toString(),
      voucherId: json['voucherId'].toString(),
      code: json['code'] ?? '',
      image: json['image'] ?? '',
      name: json['name'] ?? '',
      desc: json['desc'] ?? '',
      isUsed: json['isUsed'] ?? false,
      redeemAt: json['redeemAt'] ?? '',
      isExpired: json['isExpired'] ?? false,
      expiredAt: json['expiredAt'] ?? '',
      rating: json['rating'] ?? 0,
      comment: json['comment'] ?? '',
    );
  }
}
