import 'package:equatable/equatable.dart';

import '../../../domain/domain.dart';
import '../../data.dart';

/* 
  Equatable overrides == and hashCode for you so you don't have to waste your time writing lots of boilerplate code. 
  With Equatable there is no code generation needed.
  
  CLASS FOR MERCHANT LIST
*/

class MerchantList extends Equatable {
  final String? id;
  final String? name;
  final String? color;
  final String? image;
  final bool? isMuslim;
  final String? muslimCategory;
  final int? total;
  // final List<DeliveryLink>? external;

  const MerchantList({
    this.id,
    this.name,
    this.color,
    this.image,
    this.isMuslim,
    this.muslimCategory,
    this.total,
    // this.external,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    color,
    image,
    isMuslim,
    muslimCategory,
    total,
    // external,
  ];

  @override
  factory MerchantList.fromEntity(Entity entity) {
    if (entity is MerchantListEntity) {
      // List<DeliveryLink> external = [];
      // entity.external?.forEach((s) {
      //   external.add(DeliveryLink.fromEntity(s));
      // });

      return MerchantList(
        id: entity.id,
        name: entity.name,
        color: entity.color,
        image: entity.image,
        isMuslim: entity.isMuslim,
        muslimCategory: entity.muslimCategory,
        total: entity.total,
        // external: external,
      );
    } else {
      throw EntityModelMapperException(
        message: 'Entity should be of type MerchantListEntity',
      );
    }
  }
}
