import '../../domain.dart';

// Voucher by categories entity

class VoucherCategoriesEntity extends Entity<String> {
  final String? name;
  final String? image;
  final int? total;
  final List<VoucherEntity>? vouchers;

  const VoucherCategoriesEntity({
    required String id,
    this.name,
    this.image,
    this.total,
    this.vouchers,
  }) : super(id);

  @override
  List<Object?> get props => [id, name, image, total, vouchers];
}
