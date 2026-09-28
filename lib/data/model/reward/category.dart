import 'package:equatable/equatable.dart';

import '../../../domain/domain.dart';
import '../../data.dart';

/* 
  Equatable overrides == and hashCode for you so you don't have to waste your time writing lots of boilerplate code. 
  With Equatable there is no code generation needed.
  
  CLASS FOR CATEGORIES
*/

class CategoryReward extends Equatable {
  final String? id;
  final String? name;
  final List<VoucherReward>? vouchers;

  const CategoryReward({this.id, this.name, this.vouchers});

  @override
  List<Object?> get props => [id, name, vouchers];

  @override
  factory CategoryReward.fromEntity(Entity entity) {
    if (entity is CategoryRewardEntity) {
      List<VoucherReward> vouchers = [];
      entity.vouchers?.forEach((s) {
        vouchers.add(VoucherReward.fromEntity(s));
      });

      return CategoryReward(
        id: entity.id,
        name: entity.name,
        vouchers: vouchers,
      );
    } else {
      throw EntityModelMapperException(
        message: 'Entity should be of type CategoryRewardEntity',
      );
    }
  }
}
