import 'package:equatable/equatable.dart';

import '../../../domain/domain.dart';
import '../../data.dart';

/* 
  Equatable overrides == and hashCode for you so you don't have to waste your time writing lots of boilerplate code. 
  With Equatable there is no code generation needed.
  
  CLASS FOR IF PERKS LISTS
*/

class RewardData extends Equatable {
  final Member? member;
  final List<VoucherReward>? vouchers;
  final String? next;

  const RewardData({this.member, this.vouchers, this.next});

  @override
  List<Object?> get props => [member, vouchers, next];

  @override
  factory RewardData.fromEntity(Entity entity) {
    if (entity is RewardDataEntity) {
      List<VoucherReward> vouchers = [];
      entity.vouchers?.forEach((s) {
        vouchers.add(VoucherReward.fromEntity(s));
      });

      return RewardData(
        member: Member.fromEntity(entity.member!),
        vouchers: vouchers, //VoucherReward.fromEntity(entity.vouchers!),
        next: entity.next,
      );
    } else {
      throw EntityModelMapperException(
        message: 'Entity should be of type VoucherDataEntity',
      );
    }
  }
}
