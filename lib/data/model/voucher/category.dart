import 'package:equatable/equatable.dart';

import '../../../domain/domain.dart';
import '../../data.dart';

/* 
  Equatable overrides == and hashCode for you so you don't have to waste your time writing lots of boilerplate code. 
  With Equatable there is no code generation needed.
  
  CLASS FOR CATEGORIES
*/

class Category extends Equatable {
  final String? id;
  final String? name;
  final int? total;
  final List<Voucher>? vouchers;

  const Category({this.id, this.name, this.total, this.vouchers});

  @override
  List<Object?> get props => [id, name, total, vouchers];

  @override
  factory Category.fromEntity(Entity entity) {
    if (entity is CategoryEntity) {
      List<Voucher> vouchers = [];
      entity.vouchers?.forEach((s) {
        vouchers.add(Voucher.fromEntity(s));
      });

      return Category(
        id: entity.id,
        name: entity.name,
        total: entity.total,
        vouchers: vouchers,
      );
    } else {
      throw EntityModelMapperException(
        message: 'Entity should be of type AjEntity',
      );
    }
  }
}
