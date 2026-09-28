import '../../../../domain/domain.dart';
import '../../../data.dart';

// Outlet details model

class OutletDetailsModel extends OutletDetailsEntity {
  const OutletDetailsModel({
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
    super.isFavourite,
    super.merchantDesc,
    super.operations,
    super.vouchers,
    super.links,
  });

  factory OutletDetailsModel.fromJson(Map<String, dynamic> json) {
    List<OperationModel> operation = [];
    if (json['operations'] != null) {
      for (var s in (json['operations'] as List)) {
        {
          operation.add(OperationModel.fromJson(s));
        }
      }
    }

    List<OutletVoucherModel> voucher = [];
    if (json['vouchers'] != null) {
      for (var s in (json['vouchers'] as List)) {
        {
          voucher.add(OutletVoucherModel.fromJson(s));
        }
      }
    }

    List<DeliveryLinkModel> links = [];
    if (json['links'] != null) {
      for (var s in (json['links'] as List)) {
        {
          links.add(DeliveryLinkModel.fromJson(s));
        }
      }
    }

    return OutletDetailsModel(
      id: json['merchantId'].toString(),
      merchantId: json['merchantId'].toString(),
      merchantName: json['merchantName'] ?? '',
      image: json['image'] ?? '',
      place: json['place'] ?? '',
      contact: json['contact'] ?? '',
      address: json['address'] ?? '',
      placeId: json['placeId'] ?? '',
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
      isFavourite: json['isFavourite'] ?? false,
      merchantDesc: json['merchantDesc'] ?? '',
      operations: operation,
      vouchers: voucher,
      links: links,
    );
  }
}
