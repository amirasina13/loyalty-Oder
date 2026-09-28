import '../../../../domain/domain.dart';

// Reward Favourite list model

class RewardFavouriteModel extends RewardFavouriteEntity {
  const RewardFavouriteModel({
    required super.id,
    // final int? voucherId,
    super.isFavourite,
    super.image,
    super.type,
    super.name,
    super.desc,
    super.isMuslim,
    super.muslimCategory,
  });

  factory RewardFavouriteModel.fromJson(Map<String, dynamic> json) {
    return RewardFavouriteModel(
      id: json['voucherId'].toString(),
      // voucherId: json['voucherId'],
      isFavourite: json['isFavourite'] ?? false,
      image: json['image'] ?? '',
      type: json['type'] ?? '',
      name: json['name'] ?? '',
      desc: json['desc'] ?? '',
      isMuslim: json['isMuslim'] ?? 0,
      muslimCategory: json['muslimCategory'] ?? '',
    );
  }
}
