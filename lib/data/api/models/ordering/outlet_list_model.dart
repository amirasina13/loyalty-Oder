import '../../../../domain/domain.dart';
import '../../../data.dart';

// List outlet list model

class OutletListModel extends OutletListEntity {
  const OutletListModel({
    required super.id,
    super.merchantId,
    super.merchantName,
    super.image,
    super.place,
    super.contact,
    super.address,
    super.placeId,
    super.latitude,
    super.longitude,
    super.distance,
    super.start,
    super.end,
    super.isOpen,
    super.isFavourite,
    super.oPermissions,
    PermissionsModel? super.permissions,
  });

  factory OutletListModel.fromJson(Map<String, dynamic> json) {
    return OutletListModel(
      id: json['id'].toString(),
      merchantId: json['merchantId'].toString(),
      merchantName: json['merchantName'] ?? '',
      image: json['image'] ?? '',
      place: json['place'] ?? '',
      contact: json['contact'] ?? '',
      address: json['address'] ?? '',
      placeId: json['placeId'] ?? '',
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
      distance: json['distance'] ?? '',
      start: json['start'] ?? '',
      end: json['end'] ?? '',
      isOpen: json['isOpen'],
      isFavourite: json['isFavourite'] ?? false,
      oPermissions: json['oPermissions'] ?? '',
      permissions: PermissionsModel.fromJson(json['permissions']),
    );
  }
}
