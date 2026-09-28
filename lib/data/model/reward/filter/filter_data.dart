import 'package:equatable/equatable.dart';

import '../../../../domain/domain.dart';
import '../../../data.dart';

/* 
  Equatable overrides == and hashCode for you so you don't have to waste your time writing lots of boilerplate code. 
  With Equatable there is no code generation needed.
  
  CLASS FOR FILTER CATEGORY OPTION
*/

class FilterData extends Equatable {
  final String? title;
  final List<OptionsCategory>? options;
  final String? input;

  const FilterData({this.title, this.options, this.input});

  @override
  List<Object?> get props => [title, options];

  @override
  factory FilterData.fromEntity(Entity entity) {
    if (entity is FilterDataEntity) {
      List<OptionsCategory> options = [];
      entity.options?.forEach((s) {
        options.add(OptionsCategory.fromEntity(s));
      });

      return FilterData(
        title: entity.title,
        options: options,
        input: entity.input,
      );
    } else {
      throw EntityModelMapperException(
        message: 'Entity should be of type FilterDataEntity',
      );
    }
  }
}
