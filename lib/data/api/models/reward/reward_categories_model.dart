import '../../../../domain/domain.dart';
import '../../../data.dart';

// Vouchers categories model
// NOT USED ANYMORE

class VoucherCategoryModel extends RewwardCategoryEntity {
  const VoucherCategoryModel({
    required super.id,
    super.all,
    super.aj,
    super.kt,
    super.uz,
    super.others,
  });

  factory VoucherCategoryModel.fromJson(Map<String, dynamic> json) {
    var all = CategoryRewardModel.fromJson(json['all']);
    var aj = CategoryRewardModel.fromJson(json['aj']);
    var kt = CategoryRewardModel.fromJson(json['kt']);
    var uz = CategoryRewardModel.fromJson(json['uz']);
    var others = CategoryRewardModel.fromJson(json['others']);

    return VoucherCategoryModel(
      id: json['id'] ?? 1,
      all: all,
      aj: aj,
      kt: kt,
      uz: uz,
      others: others,
    );
  }
}

// import '../../../../domain/entities/entities.dart';
// import '../models.dart';

// // Reward with merchant categories Model

// class RewardCategoriesModel extends RewardCategoriesEntity {
//   const RewardCategoriesModel({
//     required int id,
//     final String? name,
//     final String? image,
//     final int? total,
//     final List<RewardModel>? vouchers,
//   }) : super(
//           id: id,
//           name: name,
//           image: image,
//           total: total,
//           vouchers: vouchers,
//         );

//   factory RewardCategoriesModel.fromJson(Map<String, dynamic> json) {
//     // var member = MemberModel.fromJson(json['member']);
//     // var vouchers = RewardModel.fromJson(json['vouchers']);
//     List<RewardModel> vouchers = [];
//     if (json['vouchers'] != null) {
//       for (var s in (json['vouchers'] as List)) {
//         {
//           vouchers.add(RewardModel.fromJson(s));
//         }
//       }
//     }

//     return RewardCategoriesModel(
//       id: json['id'],
//       name: json['name'] ?? '',
//       image: json['image'] ?? '',
//       total: json['total'],
//       vouchers: vouchers,
//     );
//   }
// }
