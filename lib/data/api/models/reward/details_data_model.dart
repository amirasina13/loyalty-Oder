import '../../../../domain/domain.dart';
import '../../../data.dart';

// Reward data details model

class DetailsDataModel extends DetailsDataEntity {
  const DetailsDataModel({
    required super.id,
    MemberModel? super.member,
    DetailsModel? super.voucher,
    List<RewardOutletModel>? super.outlets,
  });

  factory DetailsDataModel.fromJson(Map<String, dynamic> json) {
    var member = MemberModel.fromJson(json['member']);
    var voucher = DetailsModel.fromJson(json['voucher']);
    List<RewardOutletModel> outlets = [];
    if (json['outlets'] != null) {
      for (var s in (json['outlets'] as List)) {
        {
          outlets.add(RewardOutletModel.fromJson(s));
        }
      }
    }

    return DetailsDataModel(
      id: json['id'].toString(),
      member: member,
      voucher: voucher,
      outlets: outlets,
    );
  }
}
