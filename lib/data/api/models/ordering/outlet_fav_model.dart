import '../../../../domain/domain.dart';

// Outlet favourite list model

class OutletFavouriteModel extends OutletFavouriteEntity {
  const OutletFavouriteModel({
    required super.id,
    super.isFavourite,
    super.image,
    super.brandName,
    super.outletName,
    super.isMuslim,
    super.muslimCategory,
  });

  factory OutletFavouriteModel.fromJson(Map<String, dynamic> json) {
    return OutletFavouriteModel(
      id: json['outletId'].toString(),
      isFavourite: json['isFavourite'] ?? false,
      image: json['image'] ?? '',
      brandName: json['brandName'] ?? '',
      outletName: json['outletName'] ?? '',
      isMuslim: json['isMuslim'] ?? 0,
      muslimCategory: json['muslimCategory'] ?? '',
    );
  }
}
