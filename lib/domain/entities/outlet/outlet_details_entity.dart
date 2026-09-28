import '../../domain.dart';

// Outlet details entity

class OutletDetailsEntity extends Entity<String> {
  final String? merchantId;
  final String? merchantName;
  final String? image;
  final String? place;
  final String? contact;
  final String? address;
  final String? placeId;
  final String? latitude;
  final String? longitude;
  final bool? isFavourite;
  final String? merchantDesc;
  final List<OperationEntity>? operations;
  final List<OutletVoucherEntity>? vouchers;
  final List<DeliveryLinkEntity>? links;

  const OutletDetailsEntity({
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
    this.isFavourite,
    this.merchantDesc,
    this.operations,
    this.vouchers,
    this.links,
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
    isFavourite,
    merchantDesc,
    operations,
    vouchers,
    links,
  ];
}
