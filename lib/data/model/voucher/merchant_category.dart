import 'package:equatable/equatable.dart';

import '../../../domain/domain.dart';
import '../../data.dart';

/* 
  Equatable overrides == and hashCode for you so you don't have to waste your time writing lots of boilerplate code. 
  With Equatable there is no code generation needed.
  
  CLASS FOR MERCHANT BY CATEGORIES
*/

class MerchantCategory extends Equatable {
  final Category? all;
  final Category? aj;
  final Category? kt;
  final Category? uz;
  final Category? others;

  const MerchantCategory({this.all, this.aj, this.kt, this.uz, this.others});

  @override
  List<Object?> get props => [all, aj, kt, uz, others];

  @override
  factory MerchantCategory.fromEntity(Entity entity) {
    if (entity is MerchantCategoryEntity) {
      return MerchantCategory(
        all: Category.fromEntity(entity.all!),
        aj: Category.fromEntity(entity.aj!),
        kt: Category.fromEntity(entity.kt!),
        uz: Category.fromEntity(entity.uz!),
        others: Category.fromEntity(entity.others!),
      );
    } else {
      throw EntityModelMapperException(
        message: 'Entity should be of type MerchantCategoryEntity',
      );
    }
  }
}
