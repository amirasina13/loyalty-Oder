import '../../domain.dart';

// My voucher list entity

class VoucherDataEntity extends Entity<String> {
  final MemberEntity? member;
  final List<VoucherEntity>? vouchers;
  // final MerchantCategoryEntity? merchants;

  const VoucherDataEntity({
    required String id,
    this.member,
    this.vouchers,
    // List<VoucherModel>? vouchers,
  }) : super(id);

  @override
  List<Object?> get props => [id, member, vouchers];
}
