import '../../domain.dart';

//  Merchant bookmark entity

class MerchantBookmarkEntity extends Entity<String> {
  final bool? isFavourite;
  final String? image;
  final String? name;
  final String? desc;
  final int? isMuslim;
  final String? muslimCategory;

  const MerchantBookmarkEntity({
    required String id,
    this.isFavourite,
    this.image,
    this.name,
    this.desc,
    this.isMuslim,
    this.muslimCategory,
  }) : super(id);

  @override
  List<Object?> get props => [
    id,
    isFavourite,
    image,
    name,
    desc,
    isMuslim,
    muslimCategory,
  ];
}
