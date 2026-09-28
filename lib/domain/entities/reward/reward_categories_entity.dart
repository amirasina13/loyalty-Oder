import '../../domain.dart';

// Voucher by categories entity

class RewwardCategoryEntity extends Entity<String> {
  final CategoryRewardEntity? all;
  final CategoryRewardEntity? aj;
  final CategoryRewardEntity? kt;
  final CategoryRewardEntity? uz;
  final CategoryRewardEntity? others;

  const RewwardCategoryEntity({
    required String id,
    this.all,
    this.aj,
    this.kt,
    this.uz,
    this.others,
  }) : super(id);

  @override
  List<Object?> get props => [id, all, aj, kt, uz, others];
}

// import '../entities.dart';
// import '../entity.dart';

// // Reward/ IF Perks list entity

// class RewardCategoriesEntity extends Entity<int> {
//   final String? name;
//   final String? image;
//   final int? total;
//   final List<RewardEntity>? vouchers;

//   const RewardCategoriesEntity({
//     required int id,
//     this.name,
//     this.image,
//     this.total,
//     this.vouchers,
//   }) : super(id);

//   @override
//   List<Object?> get props => [
//         id,
//         name,
//         image,
//         total,
//         vouchers,
//       ];
// }
