import '../../../../../domain/domain.dart';

// Merchants model (will call in home_page_model.dart)

class MerchantModel extends MerchantEntity {
  const MerchantModel({
    required super.id,
    super.name,
    super.color,
    super.image,
    super.isMuslim,
    super.muslimCategory,
    super.total,
  });

  factory MerchantModel.fromJson(Map<String, dynamic> json) {
    return MerchantModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      color: json['color'] ?? '',
      image: json['image'] ?? '',
      isMuslim: json['isMuslim'],
      muslimCategory: json['muslimCategory'] ?? '',
      total: json['total'],
    );
  }
}
