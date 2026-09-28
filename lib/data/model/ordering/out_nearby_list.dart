import 'package:equatable/equatable.dart';

import '../../../domain/domain.dart';
import '../../data.dart';

/* 
  Equatable overrides == and hashCode for you so you don't have to waste your time writing lots of boilerplate code. 
  With Equatable there is no code generation needed.
  
  CLASS FOR OUTLET LIST
*/

class NearbyOutletList extends Equatable {
  final String? id;
  final String? merchantId;
  final String? merchantName;
  final String? image;
  final String? place;
  final String? contact;
  final String? address;
  final String? placeId;
  final String? latitude;
  final String? longitude;
  final String? distance;
  final String? oPermissions;
  final Permissions? permissions;

  const NearbyOutletList({
    this.id,
    this.merchantId,
    this.merchantName,
    this.image,
    this.place,
    this.contact,
    this.address,
    this.placeId,
    this.latitude,
    this.longitude,
    this.distance,
    this.oPermissions,
    this.permissions,
  });

  @override
  List<Object?> get props => [
    id,
    merchantId,
    merchantName,
    image,
    place,
    contact,
    address,
    placeId,
    latitude,
    longitude,
    distance,
    oPermissions,
    permissions,
  ];

  @override
  factory NearbyOutletList.fromEntity(Entity entity) {
    if (entity is NearbyOutletListEntity) {
      return NearbyOutletList(
        id: entity.id,
        merchantId: entity.merchantId,
        merchantName: entity.merchantName,
        image: entity.image,
        place: entity.place,
        contact: entity.contact,
        address: entity.address,
        placeId: entity.placeId,
        latitude: entity.latitude,
        longitude: entity.longitude,
        distance: entity.distance,
        oPermissions: entity.oPermissions,
        permissions: Permissions.fromEntity(
          entity.permissions ?? PermissionsEntity(id: 0),
        ),
      );
    } else {
      throw EntityModelMapperException(
        message: 'Entity should be of type NearbyOutletListEntity',
      );
    }
  }
}
