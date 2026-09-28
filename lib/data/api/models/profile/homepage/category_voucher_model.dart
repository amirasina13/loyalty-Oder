import '../../../../../domain/domain.dart';
import '../../../../data.dart';

// Category Voucher model (will call in home_page_model.dart)

class CategoryVoucherModel extends CategoryVoucherEntity {
  const CategoryVoucherModel({
    required super.id,
    super.name,
    super.image,
    super.filterBy,
    List<VouchersCatModel>? super.vouchers,
  });

  factory CategoryVoucherModel.fromJson(Map<String, dynamic> json) {
    List<VouchersCatModel> vouchers = [];
    if (json['vouchers'] != null) {
      for (var s in (json['vouchers'] as List)) {
        {
          vouchers.add(VouchersCatModel.fromJson(s));
        }
      }
    }

    return CategoryVoucherModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      filterBy: json['filterBy'] ?? '',
      vouchers: vouchers,
    );
  }
}
