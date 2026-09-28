import '../../domain.dart';

//  Outlet favourite entity

class OutletFavouriteEntity extends Entity<String> {
  final bool? isFavourite;
  final String? image;
  final String? brandName;
  final String? outletName;
  final int? isMuslim;
  final String? muslimCategory;

  const OutletFavouriteEntity({
    required String id,
    this.isFavourite,
    this.image,
    this.brandName,
    this.outletName,
    this.isMuslim,
    this.muslimCategory,
  }) : super(id);

  @override
  List<Object?> get props => [
    id,
    isFavourite,
    image,
    brandName,
    outletName,
    isMuslim,
    muslimCategory,
  ];
}
