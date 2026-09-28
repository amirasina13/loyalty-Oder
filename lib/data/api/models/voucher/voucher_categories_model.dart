import '../../../../domain/domain.dart';
import '../../../data.dart';

// Voucher by categories model

class VoucherCategoriesModel extends VoucherCategoriesEntity {
  const VoucherCategoriesModel({
    required super.id,
    super.name,
    super.image,
    super.total,
    super.vouchers,
  });

  factory VoucherCategoriesModel.fromJson(Map<String, dynamic> json) {
    List<VoucherModel> vouchers = [];
    if (json['vouchers'] != null) {
      for (var s in (json['vouchers'] as List)) {
        {
          vouchers.add(VoucherModel.fromJson(s));
        }
      }
    }

    return VoucherCategoriesModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      total: json['total'],
      vouchers: vouchers,
    );
  }
}
