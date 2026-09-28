import 'package:equatable/equatable.dart';

import '../../../domain/domain.dart';
import '../../data.dart';

/* 
  Equatable overrides == and hashCode for you so you don't have to waste your time writing lots of boilerplate code. 
  With Equatable there is no code generation needed.
  
  CLASS FOR VOUCHER BY CATEGORIES
*/

class VoucherCategories extends Equatable {
  final String? id;
  final String? name;
  final String? image;
  final int? total;
  final List<Voucher>? vouchers;

  const VoucherCategories({
    this.id,
    this.name,
    this.image,
    this.total,
    this.vouchers,
  });

  @override
  List<Object?> get props => [id, name, image, total, vouchers];

  @override
  factory VoucherCategories.fromEntity(Entity entity) {
    if (entity is VoucherCategoriesEntity) {
      List<Voucher> vouchers = [];
      entity.vouchers?.forEach((s) {
        vouchers.add(Voucher.fromEntity(s));
      });

      return VoucherCategories(
        id: entity.id,
        name: entity.name,
        image: entity.image,
        total: entity.total,
        vouchers: vouchers,
      );
    } else {
      throw EntityModelMapperException(
        message: 'Entity should be of type VoucherCategoriesEntity',
      );
    }
  }
}
