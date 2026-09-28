import '../../domain.dart';

// Merchant info entity

class MerchantInfoEntity extends Entity<String> {
  final String? name;
  final String? color;
  final String? image;
  final bool? isMuslim;
  final String? muslimCategory;
  final bool? isFavourite;
  final String? merchantDesc;
  final List<String>? menus;
  final List<SocialListEntity>? socials;

  const MerchantInfoEntity({
    required String id,
    this.name,
    this.color,
    this.image,
    this.isMuslim,
    this.muslimCategory,
    this.isFavourite,
    this.merchantDesc,
    this.menus,
    this.socials,
  }) : super(id);

  @override
  List<Object?> get props => [
    id,
    name,
    color,
    image,
    isMuslim,
    muslimCategory,
    isFavourite,
    merchantDesc,
    menus,
    socials,
  ];
}
