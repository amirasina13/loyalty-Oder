import 'package:equatable/equatable.dart';

import '../../../domain/domain.dart';
import '../../data.dart';

/* 
  Equatable overrides == and hashCode for you so you don't have to waste your time writing lots of boilerplate code. 
  With Equatable there is no code generation needed.
  
  CLASS FOR OUTLET FAVOURITE LIST 
*/

class OutletFavourite extends Equatable {
  final String? id;
  final bool? isFavourite;
  final String? image;
  final String? brandName;
  final String? outletName;
  final int? isMuslim;
  final String? muslimCategory;

  const OutletFavourite({
    this.id,
    this.isFavourite,
    this.image,
    this.brandName,
    this.outletName,
    this.isMuslim,
    this.muslimCategory,
  });

  @override
  List<Object?> get props => [
    id,
    isFavourite,
    image,
    brandName,
    outletName,
    isMuslim,
    muslimCategory,
  ];

  @override
  factory OutletFavourite.fromEntity(Entity entity) {
    if (entity is OutletFavouriteEntity) {
      return OutletFavourite(
        id: entity.id,
        isFavourite: entity.isFavourite,
        image: entity.image,
        brandName: entity.brandName,
        outletName: entity.outletName,
        isMuslim: entity.isMuslim,
        muslimCategory: entity.muslimCategory,
      );
    } else {
      throw EntityModelMapperException(
        message: 'Entity should be of type OutletFavouriteEntity',
      );
    }
  }
}
