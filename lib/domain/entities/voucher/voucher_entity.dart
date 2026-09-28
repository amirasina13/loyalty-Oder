import '../../domain.dart';

// Voucher entity

class VoucherEntity extends Entity<String> {
  final String? voucherId;
  // final String? code;
  final String? image;
  final String? name;
  final String? desc;
  final String? expired;
  final int? quantity;
  final bool? isMuslim;
  final String? muslimCategory;

  const VoucherEntity({
    required String id,
    this.voucherId,
    // this.code,
    this.image,
    this.name,
    this.desc,
    this.expired,
    this.quantity,
    this.isMuslim,
    this.muslimCategory,
  }) : super(id);

  @override
  List<Object?> get props => [
    id,
    voucherId,
    // code,
    image,
    name,
    desc,
    expired,
    quantity,
    isMuslim,
    muslimCategory,
  ];
}
