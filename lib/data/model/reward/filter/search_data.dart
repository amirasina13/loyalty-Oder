import 'package:equatable/equatable.dart';

import '../../../../domain/domain.dart';
import '../../../data.dart';

/* 
  Equatable overrides == and hashCode for you so you don't have to waste your time writing lots of boilerplate code. 
  With Equatable there is no code generation needed.
  
  CLASS FOR FILTER CATEGORY OPTION
*/

class SearchData extends Equatable {
  final String? title;
  final List<SearchListEntity>? lists;

  const SearchData({this.title, this.lists});

  @override
  List<Object?> get props => [title, lists];

  @override
  factory SearchData.fromEntity(Entity entity) {
    if (entity is SearchDataEntity) {
      List<SearchLists> lists = [];
      entity.lists?.forEach((s) {
        lists.add(SearchLists.fromEntity(s));
      });

      return SearchData(title: entity.title, lists: entity.lists);
    } else {
      throw EntityModelMapperException(
        message: 'Entity should be of type SearchDataEntity',
      );
    }
  }
}
