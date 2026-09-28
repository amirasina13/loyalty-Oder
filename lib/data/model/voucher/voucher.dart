import 'package:equatable/equatable.dart';

import '../../../domain/domain.dart';
import '../../data.dart';

/* 
  Equatable overrides == and hashCode for you so you don't have to waste your time writing lots of boilerplate code. 
  With Equatable there is no code generation needed.
  
  CLASS FOR ACTIVE VOUCHER LIST 
*/

class Voucher extends Equatable {
  final String? voucherId;
  // final String? code;
  final String? image;
  final String? name;
  final String? desc;
  final String? expired;
  final int? quantity;
  final bool? isMuslim;
  final String? muslimCategory;

  const Voucher({
    this.voucherId,
    // this.code,
    this.image,
    this.name,
    this.desc,
    this.expired,
    this.quantity,
    this.isMuslim,
    this.muslimCategory,
  });

  @override
  List<Object?> get props => [
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

  @override
  factory Voucher.fromEntity(Entity entity) {
    if (entity is VoucherEntity) {
      return Voucher(
        voucherId: entity.voucherId,
        // code: entity.code,
        image: entity.image,
        name: entity.name,
        desc: entity.desc,
        expired: entity.expired,
        quantity: entity.quantity,
        isMuslim: entity.isMuslim,
        muslimCategory: entity.muslimCategory,
      );
    } else {
      throw EntityModelMapperException(
        message: 'Entity should be of type VoucherEntity',
      );
    }
  }
}
