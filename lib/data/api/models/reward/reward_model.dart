import '../../../../domain/domain.dart';

// Reward List Model (Will call in reward_data_model.dart)

class RewardModel extends RewardEntity {
  const RewardModel({
    required super.id,
    super.image,
    super.name,
    super.desc,
    super.isPoint,
    super.points,
    super.isCredit,
    super.credits,
    super.isMuslim,
    super.muslimCategory,
    super.isDiscount,
    super.aftDisPoints,
    super.aftDisCredits,
  });

  factory RewardModel.fromJson(Map<String, dynamic> json) {
    return RewardModel(
      id: json['id'].toString(),
      image: json['image'] ?? '',
      name: json['name'] ?? '',
      desc: json['desc'] ?? '',
      isPoint: json['isPoint'],
      points: json['points'] ?? '',
      isCredit: json['isCredit'],
      credits: json['credits'] ?? '',
      isMuslim: json['isMuslim'],
      muslimCategory: json['muslimCategory'] ?? '',
      isDiscount: json['isDiscount'] ?? '',
      aftDisPoints: json['aftDisPoints'] ?? '',
      aftDisCredits: json['aftDisCredits'] ?? '',
    );
  }
}
