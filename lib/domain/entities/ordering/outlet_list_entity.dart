import '../../domain.dart';

// Outlet list entity

class OutletListEntity extends Entity<String> {
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
  final String? start;
  final String? end;
  final bool? isOpen;
  final bool? isFavourite;
  final String? oPermissions;
  final PermissionsEntity? permissions;

  const OutletListEntity({
    required String id,
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
    this.start,
    this.end,
    this.isOpen,
    this.isFavourite,
    this.oPermissions,
    this.permissions,
  }) : super(id);

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
    start,
    end,
    isOpen,
    isFavourite,
    oPermissions,
    permissions,
  ];
}
