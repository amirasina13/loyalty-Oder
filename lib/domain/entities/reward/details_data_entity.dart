import '../../domain.dart';

// Reward/ IF Perks details entity

class DetailsDataEntity extends Entity<String> {
  final MemberEntity? member;
  final DetailsEntity? voucher;
  final List<RewardOutletEntity>? outlets;

  const DetailsDataEntity({
    required String id,
    this.member,
    this.voucher,
    this.outlets,
  }) : super(id);

  @override
  List<Object?> get props => [id, member, voucher, outlets];
}
