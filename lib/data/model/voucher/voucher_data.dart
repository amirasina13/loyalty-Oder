import 'package:equatable/equatable.dart';

import '../../../domain/domain.dart';
import '../../data.dart';

/* 
  Equatable overrides == and hashCode for you so you don't have to waste your time writing lots of boilerplate code. 
  With Equatable there is no code generation needed.
  
  CLASS FOR MY VOUCHER LISTS
*/

class VoucherData extends Equatable {
  final Member? member;
  final List<Voucher>? vouchers;
  // final MerchantCategory? merchants;
  // final List<VoucherCategories>? merchants;

  const VoucherData({this.member, this.vouchers});

  @override
  List<Object?> get props => [member, vouchers];

  @override
  factory VoucherData.fromEntity(Entity entity) {
    if (entity is VoucherDataEntity) {
      List<Voucher> vouchers = [];
      entity.vouchers?.forEach((s) {
        vouchers.add(Voucher.fromEntity(s));
      });

      return VoucherData(
        member: Member.fromEntity(entity.member!),
        vouchers: vouchers,
        // merchants: MerchantCategory.fromEntity(entity.merchants!),
      );
    } else {
      throw EntityModelMapperException(
        message: 'Entity should be of type VoucherDataEntity',
      );
    }
  }
}
