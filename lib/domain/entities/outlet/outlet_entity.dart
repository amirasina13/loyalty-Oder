import '../../domain.dart';

// Outlet entity

class OutletEntity extends Entity<String> {
  final String? merchantId;
  final String? merchantName;
  final String? place;
  final String? address;
  final String? placeId;
  final String? latitude;
  final String? longitude;

  const OutletEntity({
    required String id,
    this.merchantId,
    this.merchantName,
    this.place,
    this.address,
    this.placeId,
    this.latitude,
    this.longitude,
  }) : super(id);

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
}
