import '../../domain.dart';

// Voucher past entity

class VoucherPastEntity extends Entity<String> {
  final String? voucherId;
  final String? code;
  final String? image;
  final String? name;
  final String? desc;
  final bool? isUsed;
  final String? usedAt;
  final bool? isExpired;
  final String? expiredAt;
  final int? rating;
  final String? comment;

  const VoucherPastEntity({
    required String id,
    this.voucherId,
    this.code,
    this.image,
    this.name,
    this.desc,
    this.isUsed,
    this.usedAt,
    this.isExpired,
    this.expiredAt,
    this.rating,
    this.comment,
  }) : super(id);

  @override
  List<Object?> get props => [
    id,
    voucherId,
    code,
    image,
    name,
    desc,
    isUsed,
    usedAt,
    isExpired,
    expiredAt,
    rating,
    comment,
  ];
}
