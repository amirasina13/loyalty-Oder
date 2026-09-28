import '../../../../domain/domain.dart';

// Member model (will call in details_data_model.dart)

class MemberModel extends MemberEntity {
  const MemberModel({
    required super.id,
    super.points,
    super.credits,
    super.coins,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      id: json['id'].toString(),
      points: json['points'],
      credits: json['credits'],
      coins: json['coins'],
    );
  }
}
