import 'package:equatable/equatable.dart';

import '../../../../domain/domain.dart';
import '../../../data.dart';

/* 
  Equatable overrides == and hashCode for you so you don't have to waste your time writing lots of boilerplate code. 
  With Equatable there is no code generation needed.
  
  CLASS FOR HOMEPAGE MERCHANT
*/

class Merchant extends Equatable {
  final String? id;
  final String? name;
  final String? color;
  final String? image;
  final bool? isMuslim;
  final String? muslimCategory;
  final int? total;

  const Merchant({
    this.id,
    this.name,
    this.color,
    this.image,
    this.isMuslim,
    this.muslimCategory,
    this.total,
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
  ];

  @override
  factory Merchant.fromEntity(Entity entity) {
    if (entity is MerchantEntity) {
      return Merchant(
        id: entity.id,
        name: entity.name,
        color: entity.color,
        image: entity.image,
        isMuslim: entity.isMuslim,
        muslimCategory: entity.muslimCategory,
        total: entity.total,
      );
    } else {
      throw EntityModelMapperException(
        message: 'Entity should be of type MerchantEntity',
      );
    }
  }
}
