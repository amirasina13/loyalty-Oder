import '../../domain.dart';

// Outlet voucher entity. Will call in outlet_details_entity.dart

class OutletVoucherEntity extends Entity<String> {
  final String? image;
  final String? type;
  final String? name;
  final String? desc;
  final String? purchaseMethod;
  final String? points;
  final String? credits;
  final String? quantity;
  final bool? isMuslim;
  final String? muslimCategory;
  final String? faceAmount;
  final bool? isDiscount;
  final String? aftDisPoints;
  final String? aftDisCredits;
  final String? aftDisCoins;
  final String? purchaseText;
  final String? voucherType;
  final bool? isSoldOut;

  const OutletVoucherEntity({
    required String id,
    this.image,
    this.type,
    this.name,
    this.desc,
    this.purchaseMethod,
    this.points,
    this.credits,
    this.quantity,
    this.isMuslim,
    this.muslimCategory,
    this.faceAmount,
    this.isDiscount,
    this.aftDisPoints,
    this.aftDisCredits,
    this.aftDisCoins,
    this.purchaseText,
    this.voucherType,
    this.isSoldOut,
  }) : super(id);

  @override
  List<Object?> get props => [
    id,
    image,
    type,
    name,
    desc,
    purchaseMethod,
    points,
    credits,
    quantity,
    isMuslim,
    muslimCategory,
    faceAmount,
    isDiscount,
    aftDisPoints,
    aftDisCredits,
    aftDisCoins,
    purchaseText,
    voucherType,
    isSoldOut,
  ];
}
