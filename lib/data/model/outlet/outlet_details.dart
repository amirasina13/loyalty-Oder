import 'package:equatable/equatable.dart';

import '../../../domain/domain.dart';
import '../../data.dart';

/* 
  Equatable overrides == and hashCode for you so you don't have to waste your time writing lots of boilerplate code. 
  With Equatable there is no code generation needed.
  
  CLASS FOR OUTLET DETAILS
*/

class OutletDetails extends Equatable {
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
  final bool? isFavourite;
  final String? merchantDesc;
  final List<Operation>? operations;
  final List<VoucherOutlet>? vouchers;
  final List<DeliveryLink>? links;

  const OutletDetails({
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
    this.isFavourite,
    this.merchantDesc,
    this.operations,
    this.vouchers,
    this.links,
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
    isFavourite,
    merchantDesc,
    operations,
    vouchers,
    links,
  ];

  @override
  factory OutletDetails.fromEntity(Entity entity) {
    if (entity is OutletDetailsEntity) {
      List<Operation> operations = [];
      entity.operations?.forEach((s) {
        operations.add(Operation.fromEntity(s));
      });

      List<VoucherOutlet> vouchers = [];
      entity.vouchers?.forEach((s) {
        vouchers.add(VoucherOutlet.fromEntity(s));
      });

      List<DeliveryLink> links = [];
      entity.links?.forEach((s) {
        links.add(DeliveryLink.fromEntity(s));
      });

      return OutletDetails(
        id: entity.merchantId,
        merchantId: entity.merchantId,
        merchantName: entity.merchantName,
        image: entity.image,
        place: entity.place,
        contact: entity.contact,
        address: entity.address,
        placeId: entity.placeId,
        latitude: entity.latitude,
        longitude: entity.longitude,
        isFavourite: entity.isFavourite,
        merchantDesc: entity.merchantDesc,
        operations: operations,
        vouchers: vouchers,
        links: links,
      );
    } else {
      throw EntityModelMapperException(
        message: 'Entity should be of type OutletDetailsEntity',
      );
    }
  }
}
