import '../../../domain.dart';

// Voucher entity. Will call in home_page_entity.dart

class VouchersCatEntity extends Entity<String> {
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
  final bool? isTimeLimit;
  final String? timeStart;
  final String? timeEnd;
  final bool? isDiscount;
  final String? aftDisPoints;
  final String? aftDisCredits;
  final String? purchaseText;
  final String? voucherType;
  final bool? isSoldOut;

  const VouchersCatEntity({
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
    this.isTimeLimit,
    this.timeStart,
    this.timeEnd,
    this.isDiscount,
    this.aftDisPoints,
    this.aftDisCredits,
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
    isTimeLimit,
    timeStart,
    timeEnd,
    isDiscount,
    aftDisPoints,
    aftDisCredits,
    purchaseText,
    voucherType,
    isSoldOut,
  ];
}
