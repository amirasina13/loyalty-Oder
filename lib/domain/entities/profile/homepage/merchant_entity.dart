import '../../../domain.dart';

// Reward/ IF Perks list entity

class MerchantEntity extends Entity<String> {
  final String? name;
  final String? color;
  final String? image;
  final bool? isMuslim;
  final String? muslimCategory;
  final int? total;

  const MerchantEntity({
    required String id,
    this.name,
    this.color,
    this.image,
    this.isMuslim,
    this.muslimCategory,
    this.total,
  }) : super(id);

  @override
  List<Object?> get props => [
    id,
    name,
    color,
    image,
    isMuslim,
    muslimCategory,
    total,
  ];
}
