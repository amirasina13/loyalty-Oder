import '../../../../domain/domain.dart';
import '../../../data.dart';

// Category model

class CategoryRewardModel extends CategoryRewardEntity {
  const CategoryRewardModel({required super.id, super.name, super.vouchers});

  factory CategoryRewardModel.fromJson(Map<String, dynamic> json) {
    List<VoucherRewardModel> vouchers = [];
    if (json['vouchers'] != null) {
      for (var s in (json['vouchers'] as List)) {
        {
          vouchers.add(VoucherRewardModel.fromJson(s));
        }
      }
    }

    return CategoryRewardModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      vouchers: vouchers,
    );
  }
}
