import 'package:equatable/equatable.dart';

import '../../../domain/domain.dart';
import '../../data.dart';

/* 
  Equatable overrides == and hashCode for you so you don't have to waste your time writing lots of boilerplate code. 
  With Equatable there is no code generation needed.
  
  CLASS FOR OUTLET DETAILS. WILL CALL IN SUBSCRIPTION_DETAILS.DART
*/

class RewardOutlet extends Equatable {
  final String? id;
  final String? merchantId;
  final String? merchantName;
  final String? merchantImg;
  final String? place;
  final String? address;
  final String? placeId;
  final String? latitude;
  final String? longitude;
  final String? distance;

  const RewardOutlet({
    this.id,
    this.merchantId,
    this.merchantName,
    this.merchantImg,
    this.place,
    this.address,
    this.placeId,
    this.latitude,
    this.longitude,
    this.distance,
  });

  @override
  List<Object?> get props => [
    id,
    merchantId,
    merchantName,
    merchantImg,
    place,
    address,
    placeId,
    latitude,
    longitude,
    distance,
  ];

  @override
  factory RewardOutlet.fromEntity(Entity entity) {
    if (entity is RewardOutletEntity) {
      return RewardOutlet(
        id: entity.id,
        merchantId: entity.merchantId,
        merchantName: entity.merchantName,
        merchantImg: entity.merchantImg,
        place: entity.place,
        address: entity.address,
        placeId: entity.placeId,
        latitude: entity.latitude,
        longitude: entity.longitude,
        distance: entity.distance,
      );
    } else {
      throw EntityModelMapperException(
        message: 'Entity should be of type RewardEntity',
      );
    }
  }
}
