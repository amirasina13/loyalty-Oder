import '../../domain.dart';

// List reward voucher entity. Will call in reward_data_entity.dart

class RewardEntity extends Entity<String> {
  final String? image;
  final String? name;
  final String? desc;
  final bool? isPoint;
  final String? points;
  final bool? isCredit;
  final String? credits;
  final bool? isMuslim;
  final String? muslimCategory;
  final bool? isDiscount;
  final String? aftDisPoints;
  final String? aftDisCredits;

  const RewardEntity({
    required String id,
    this.image,
    this.name,
    this.desc,
    this.isPoint,
    this.points,
    this.isCredit,
    this.credits,
    this.isMuslim,
    this.muslimCategory,
    this.isDiscount,
    this.aftDisPoints,
    this.aftDisCredits,
  }) : super(id);

  @override
  List<Object?> get props => [
    id,
    image,
    name,
    desc,
    isPoint,
    points,
    isCredit,
    credits,
    isMuslim,
    muslimCategory,
    isDiscount,
    aftDisPoints,
    aftDisCredits,
  ];
}
