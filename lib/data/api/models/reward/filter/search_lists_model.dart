// Reward Outlet model (will call in details_data_model.dart)

import '../../../../../domain/domain.dart';

class SearchListsModel extends SearchListEntity {
  const SearchListsModel({
    required super.id,
    super.type,
    super.name,
    super.image,
    super.isMuslim,
    super.muslimCategory,
  });

  factory SearchListsModel.fromJson(Map<String, dynamic> json) {
    return SearchListsModel(
      id: json['id'].toString(),
      type: json['type'],
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      isMuslim: json['isMuslim'] ?? '',
      muslimCategory: json['muslimCategory'] ?? '',
    );
  }
}
