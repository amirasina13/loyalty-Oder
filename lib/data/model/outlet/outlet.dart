import 'package:equatable/equatable.dart';

import '../../../domain/domain.dart';
import '../../data.dart';

class Outlet extends Equatable {
  final String? id;
  final String? merchantId;
  final String? merchantName;
  final String? place;
  final String? address;
  final String? placeId;
  final String? latitude;
  final String? longitude;

  const Outlet({
    this.id,
    this.merchantId,
    this.merchantName,
    this.place,
    this.address,
    this.placeId,
    this.latitude,
    this.longitude,
  });

  @override
  List<Object?> get props => [
    id,
    merchantId,
    merchantName,
    place,
    address,
    placeId,
    latitude,
    longitude,
  ];

  @override
  factory Outlet.fromEntity(Entity entity) {
    if (entity is OutletEntity) {
      return Outlet(
        id: entity.id,
        merchantId: entity.merchantId,
        merchantName: entity.merchantName,
        place: entity.place,
        address: entity.address,
        placeId: entity.placeId,
        latitude: entity.latitude,
        longitude: entity.longitude,
      );
    } else {
      throw EntityModelMapperException(
        message: 'Entity should be of type OutletEntity',
      );
    }
  }
}
