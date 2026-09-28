import '../../../../domain/domain.dart';
import '../../../data.dart';

// Merchant list model

class NearbyOutletListModel extends NearbyOutletListEntity {
  const NearbyOutletListModel({
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
    super.oPermissions,
    PermissionsModel? super.permissions,
  });

  factory NearbyOutletListModel.fromJson(Map<String, dynamic> json) {
    List<DeliveryLinkModel> external = [];
    if (json['external'] != null) {
      for (var s in (json['external'] as List)) {
        {
          external.add(DeliveryLinkModel.fromJson(s));
        }
      }
    }

    return NearbyOutletListModel(
      id: json['id'].toString(),
      merchantId: json['merchantId'].toString(),
      merchantName: json['merchantName'] ?? '',
      image: json['image'],
      place: json['place'] ?? '',
      contact: json['contact'] ?? '',
      address: json['address'] ?? '',
      placeId: json['placeId'] ?? '',
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
      distance: json['distance'] ?? '',
      oPermissions: json['oPermissions'] ?? '',
      permissions: PermissionsModel.fromJson(json['permissions']),
    );
  }
}
