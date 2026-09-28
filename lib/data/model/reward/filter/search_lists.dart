import 'package:equatable/equatable.dart';

import '../../../../domain/domain.dart';
import '../../../data.dart';

/* 
  Equatable overrides == and hashCode for you so you don't have to waste your time writing lots of boilerplate code. 
  With Equatable there is no code generation needed.
  
  CLASS FOR OPTIONS CATEGORY 
*/

class SearchLists extends Equatable {
  final String? id;
  final String? type;
  final String? name;
  final String? image;
  final String? isMuslim;
  final String? muslimCategory;

  const SearchLists({
    this.id,
    this.type,
    this.name,
    this.image,
    this.isMuslim,
    this.muslimCategory,
  });

  @override
  List<Object?> get props => [id, type, name, image, isMuslim, muslimCategory];

  @override
  factory SearchLists.fromEntity(Entity entity) {
    if (entity is SearchListEntity) {
      return SearchLists(
        id: entity.id,
        type: entity.type,
        name: entity.name,
        image: entity.image,
        isMuslim: entity.isMuslim,
        muslimCategory: entity.isMuslim,
      );
    } else {
      throw EntityModelMapperException(
        message: 'Entity should be of type SearchListsEntity',
      );
    }
  }
}
