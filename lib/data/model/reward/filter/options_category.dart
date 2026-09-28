import 'package:equatable/equatable.dart';

import '../../../../domain/domain.dart';
import '../../../data.dart';

/* 
  Equatable overrides == and hashCode for you so you don't have to waste your time writing lots of boilerplate code. 
  With Equatable there is no code generation needed.
  
  CLASS FOR OPTIONS CATEGORY 
*/

class OptionsCategory extends Equatable {
  final String? id;
  final String? name;
  final String? image;
  final String? filterBy;

  const OptionsCategory({this.id, this.name, this.image, this.filterBy});

  @override
  List<Object?> get props => [id, name, image, filterBy];

  @override
  factory OptionsCategory.fromEntity(Entity entity) {
    if (entity is OptionsCategoryEntity) {
      return OptionsCategory(
        id: entity.id,
        name: entity.name,
        image: entity.image,
        filterBy: entity.filterBy,
      );
    } else {
      throw EntityModelMapperException(
        message: 'Entity should be of type OptionsCategoryEntity',
      );
    }
  }
}
