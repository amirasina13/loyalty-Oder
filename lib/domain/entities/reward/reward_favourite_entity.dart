import '../../domain.dart';

//  Reward favourite entity

class RewardFavouriteEntity extends Entity<String> {
  // final int? voucherId;
  final bool? isFavourite;
  final String? image;
  final String? type;
  final String? name;
  final String? desc;
  final int? isMuslim;
  final String? muslimCategory;

  const RewardFavouriteEntity({
    required String id,
    // this.voucherId,
    this.isFavourite,
    this.image,
    this.type,
    this.name,
    this.desc,
    this.isMuslim,
    this.muslimCategory,
  }) : super(id);

  @override
  List<Object?> get props => [
    id,
    // voucherId,
    isFavourite,
    image,
    type,
    name,
    desc,
    isMuslim,
    muslimCategory,
  ];
}
