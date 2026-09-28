import 'package:equatable/equatable.dart';

import '../../../domain/domain.dart';
import '../../data.dart';

/* 
  Equatable overrides == and hashCode for you so you don't have to waste your time writing lots of boilerplate code. 
  With Equatable there is no code generation needed.
  
  CLASS FOR REWARD FAVOURITE LIST 
*/

class RewardFavourite extends Equatable {
  final String? id;
  // final int? voucherId;
  final bool? isFavourite;
  final String? image;
  final String? type;
  final String? name;
  final String? desc;
  final int? isMuslim;
  final String? muslimCategory;

  const RewardFavourite({
    this.id,
    // this.voucherId,
    this.isFavourite,
    this.image,
    this.type,
    this.name,
    this.desc,
    this.isMuslim,
    this.muslimCategory,
  });

  @override
  List<Object?> get props => [
    id,
    // voucherId,
    isFavourite,
    image,
    type,
    name,
    desc,
    isMuslim,
    muslimCategory,
  ];

  @override
  factory RewardFavourite.fromEntity(Entity entity) {
    if (entity is RewardFavouriteEntity) {
      return RewardFavourite(
        id: entity.id,
        // voucherId: entity.voucherId,
        isFavourite: entity.isFavourite,
        image: entity.image,
        type: entity.type,
        name: entity.name,
        desc: entity.desc,
        isMuslim: entity.isMuslim,
        muslimCategory: entity.muslimCategory,
      );
    } else {
      throw EntityModelMapperException(
        message: 'Entity should be of type RewardFavouriteEntity',
      );
    }
  }
}
