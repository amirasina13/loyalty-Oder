import '../../../../domain/domain.dart';

// Reward Favourite list model

class MerchantBookmarkModel extends MerchantBookmarkEntity {
  const MerchantBookmarkModel({
    required super.id,
    super.isFavourite,
    super.image,
    super.name,
    super.desc,
    super.isMuslim,
    super.muslimCategory,
  });

  factory MerchantBookmarkModel.fromJson(Map<String, dynamic> json) {
    return MerchantBookmarkModel(
      id: json['merchantId'].toString(),
      isFavourite: json['isFavourite'] ?? false,
      image: json['image'] ?? '',
      name: json['name'] ?? '',
      desc: json['desc'] ?? '',
      isMuslim: json['isMuslim'] ?? 0,
      muslimCategory: json['muslimCategory'] ?? '',
    );
  }
}
