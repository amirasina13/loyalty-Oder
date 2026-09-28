import '../../domain.dart';

// Reward/ IF Perks list entity

class RewardDataEntity extends Entity<String> {
  final MemberEntity? member;
  final List<VoucherRewardEntity>? vouchers;
  final String? next;

  const RewardDataEntity({
    required String id,
    this.member,
    this.vouchers,
    this.next,
  }) : super(id);

  @override
  List<Object?> get props => [id, member, vouchers, next];
}
