// Reward Outlet model (will call in details_data_model.dart)

import '../../../../../domain/domain.dart';

class OptionsCategoryModel extends OptionsCategoryEntity {
  const OptionsCategoryModel({
    required super.id,
    super.name,
    super.image,
    super.filterBy,
  });

  factory OptionsCategoryModel.fromJson(Map<String, dynamic> json) {
    return OptionsCategoryModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      filterBy: json['filterBy'] ?? '',
    );
  }
}
