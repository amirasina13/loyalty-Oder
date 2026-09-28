import '../../../../domain/domain.dart';

// Voucher past list model

class VoucherPastModel extends VoucherPastEntity {
  const VoucherPastModel({
    required super.id,
    super.voucherId,
    super.code,
    super.image,
    super.name,
    super.desc,
    super.isUsed,
    super.usedAt,
    super.isExpired,
    super.expiredAt,
    super.rating,
    super.comment,
  });

  factory VoucherPastModel.fromJson(Map<String, dynamic> json) {
    return VoucherPastModel(
      id: json['id'].toString(),
      voucherId: json['voucherId'].toString(),
      code: json['code'] ?? '',
      image: json['image'] ?? '',
      name: json['name'] ?? '',
      desc: json['desc'] ?? '',
      isUsed: json['isUsed'] ?? false,
      usedAt: json['usedAt'] ?? '',
      isExpired: json['isExpired'] ?? false,
      expiredAt: json['expiredAt'] ?? '',
      rating: json['rating'] ?? 0,
      comment: json['comment'] ?? '',
    );
  }
}
