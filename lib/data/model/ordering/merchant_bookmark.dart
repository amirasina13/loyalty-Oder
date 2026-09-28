import 'package:equatable/equatable.dart';

import '../../../domain/domain.dart';
import '../../data.dart';

/* 
  Equatable overrides == and hashCode for you so you don't have to waste your time writing lots of boilerplate code. 
  With Equatable there is no code generation needed.
  
  CLASS FOR MERCHANT BOOKMARK LIST 
*/

class MerchantBookmark extends Equatable {
  final String? id;
  final bool? isFavourite;
  final String? image;
  final String? name;
  final String? desc;
  final int? isMuslim;
  final String? muslimCategory;

  const MerchantBookmark({
    this.id,
    this.isFavourite,
    this.image,
    this.name,
    this.desc,
    this.isMuslim,
    this.muslimCategory,
  });

  @override
  List<Object?> get props => [
    id,
    isFavourite,
    image,
    name,
    desc,
    isMuslim,
    muslimCategory,
  ];

  @override
  factory MerchantBookmark.fromEntity(Entity entity) {
    if (entity is MerchantBookmarkEntity) {
      return MerchantBookmark(
        id: entity.id,
        isFavourite: entity.isFavourite,
        image: entity.image,
        name: entity.name,
        desc: entity.desc,
        isMuslim: entity.isMuslim,
        muslimCategory: entity.muslimCategory,
      );
    } else {
      throw EntityModelMapperException(
        message: 'Entity should be of type MerchantBookmarkEntity',
      );
    }
  }
}
