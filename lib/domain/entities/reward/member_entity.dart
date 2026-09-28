import '../../domain.dart';

// Member entity. Will call in details_data_entity.dart & reward_data_entiy.dart

class MemberEntity extends Entity<String> {
  final String? points;
  final String? credits;
  final String? coins;

  const MemberEntity({
    required String id,
    this.points,
    this.credits,
    this.coins,
  }) : super(id);

  @override
  List<Object?> get props => [id, points, credits, coins];
}
