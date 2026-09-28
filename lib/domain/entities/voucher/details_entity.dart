import '../../domain.dart';

// Voucher details entity

class VoucherDetailsEntity extends Entity<String> {
  final String? voucherId;
  final String? image;
  final String? type;
  final String? name;
  final String? desc;
  final String? code;
  final String? expired;
  final bool? isMuslim;
  final String? muslimCategory;
  final String? purchaseMethod;
  final String? redeemMethod;
  final String? tnc;
  final String? voucherType;
  final String? share;
  final String? shareLink;
  final String? qr;
  final String? barcode;
  final List<RewardOutletEntity>? outlets;

  const VoucherDetailsEntity({
    required String id,
    this.voucherId,
    this.image,
    this.type,
    this.name,
    this.desc,
    this.code,
    this.expired,
    this.isMuslim,
    this.muslimCategory,
    this.purchaseMethod,
    this.redeemMethod,
    this.tnc,
    this.voucherType,
    this.share,
    this.shareLink,
    this.qr,
    this.barcode,
    this.outlets,
  }) : super(id);

  @override
  List<Object?> get props => [
    id,
    voucherId,
    image,
    type,
    name,
    desc,
    code,
    expired,
    isMuslim,
    muslimCategory,
    purchaseMethod,
    redeemMethod,
    tnc,
    voucherType,
    share,
    shareLink,
    qr,
    barcode,
    outlets,
  ];
}
