import '../../../../domain/domain.dart';
import '../../../data.dart';

// Merchant list model

class MerchantInfoModel extends MerchantInfoEntity {
  const MerchantInfoModel({
    required super.id,
    super.name,
    super.color,
    super.image,
    super.isMuslim,
    super.muslimCategory,
    super.isFavourite,
    super.merchantDesc,
    super.menus,
    List<SocialListModel>? super.socials,
  });

  factory MerchantInfoModel.fromJson(Map<String, dynamic> json) {
    List<String> menus = [];
    if (json['menus'] != null) {
      for (var s in (json['menus'] as List)) {
        {
          menus.add(s);
        }
      }
    }

    List<SocialListModel> socials = [];
    if (json['socials'] != null) {
      for (var s in (json['socials'] as List)) {
        {
          socials.add(SocialListModel.fromJson(s));
        }
      }
    }

    return MerchantInfoModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      color: json['color'] ?? '',
      image: json['image'] ?? '',
      isMuslim: json['isMuslim'],
      muslimCategory: json['muslimCategory'] ?? '',
      isFavourite: json['isFavourite'] ?? false,
      merchantDesc: json['merchantDesc'] ?? '',
      menus: menus,
      socials: socials,
    );
  }
}
