import '../../../../domain/domain.dart';

// voucher active list model

class VoucherModel extends VoucherEntity {
  const VoucherModel({
    required super.id,
    super.voucherId,
    // final String? code,
    super.image,
    super.name,
    super.desc,
    super.expired,
    super.quantity,
    super.isMuslim,
    super.muslimCategory,
  });

  factory VoucherModel.fromJson(Map<String, dynamic> json) {
    return VoucherModel(
      id: json['voucherId'].toString(),
      voucherId: json['voucherId'].toString(),
      // code: json['code'] ?? '',
      image: json['image'] ?? '',
      name: json['name'] ?? '',
      desc: json['desc'] ?? '',
      expired: json['expired'] ?? '',
      quantity: json['quantity'],
      isMuslim: json['isMuslim'],
      muslimCategory: json['muslimCategory'] ?? '',
    );
  }
}
