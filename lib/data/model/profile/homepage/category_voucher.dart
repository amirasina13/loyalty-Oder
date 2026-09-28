import 'package:equatable/equatable.dart';

import '../../../../domain/domain.dart';
import '../../../data.dart';

/* 
  Equatable overrides == and hashCode for you so you don't have to waste your time writing lots of boilerplate code. 
  With Equatable there is no code generation needed.
  
  CLASS FOR HOMEPAGE CATEGORY VOUCHER
*/

class CategoryVoucher extends Equatable {
  final String? id;
  final String? name;
  final String? image;
  final String? filterBy;
  final List<VouchersCat>? vouchers;

  const CategoryVoucher({
    this.id,
    this.name,
    this.image,
    this.filterBy,
    this.vouchers,
  });

  @override
  List<Object?> get props => [id, name, image, filterBy, vouchers];

  @override
  factory CategoryVoucher.fromEntity(Entity entity) {
    if (entity is CategoryVoucherEntity) {
      List<VouchersCat> vouchers = [];
      entity.vouchers?.forEach((s) {
        vouchers.add(VouchersCat.fromEntity(s));
      });

      return CategoryVoucher(
        id: entity.id,
        name: entity.name,
        image: entity.image,
        filterBy: entity.filterBy,
        vouchers: vouchers,
      );
    } else {
      throw EntityModelMapperException(
        message: 'Entity should be of type CategoryVoucherEntity',
      );
    }
  }
}
