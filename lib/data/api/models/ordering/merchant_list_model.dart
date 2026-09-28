import '../../../../domain/domain.dart';

// Merchant list model

class MerchantListModel extends MerchantListEntity {
  const MerchantListModel({
    required super.id,
    super.name,
    super.color,
    super.image,
    super.isMuslim,
    super.muslimCategory,
    super.total,
  });

  factory MerchantListModel.fromJson(Map<String, dynamic> json) {
    return MerchantListModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      color: json['color'] ?? '',
      image: json['image'] ?? '',
      isMuslim: json['isMuslim'],
      muslimCategory: json['muslimCategory'] ?? '',
      total: json['total'] ?? 0,
    );
  }
}
