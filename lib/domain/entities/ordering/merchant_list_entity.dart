import '../../domain.dart';

// Merchant list entity

class MerchantListEntity extends Entity<String> {
  final String? name;
  final String? color;
  final String? image;
  final bool? isMuslim;
  final String? muslimCategory;
  final int? total;
  // final List<DeliveryLinkEntity>? external;

  const MerchantListEntity({
    required String id,
    this.name,
    this.color,
    this.image,
    this.isMuslim,
    this.muslimCategory,
    this.total,
    // this.external,
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
    // external,
  ];
}
