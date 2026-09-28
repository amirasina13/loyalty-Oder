import '../../domain.dart';

// Voucher by categories entity

class MerchantCategoryEntity extends Entity<int> {
  final CategoryEntity? all;
  final CategoryEntity? aj;
  final CategoryEntity? kt;
  final CategoryEntity? uz;
  final CategoryEntity? others;

  const MerchantCategoryEntity({
    required int id,
    this.all,
    this.aj,
    this.kt,
    this.uz,
    this.others,
  }) : super(id);

  @override
  List<Object?> get props => [id, all, aj, kt, uz, others];
}
