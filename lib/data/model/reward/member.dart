import 'package:equatable/equatable.dart';

import '../../../domain/domain.dart';
import '../../data.dart';

/* 
  Equatable overrides == and hashCode for you so you don't have to waste your time writing lots of boilerplate code. 
  With Equatable there is no code generation needed.
  
  CLASS FOR IF PERKS DETAILS MEMBER. WILL CALL IN DETAILS_DATA.DART & REWARD_DATA.DART
*/

class Member extends Equatable {
  final String? points;
  final String? credits;
  final String? coins;

  const Member({this.points, this.credits, this.coins});

  @override
  List<Object?> get props => [points, credits, coins];

  @override
  factory Member.fromEntity(Entity entity) {
    if (entity is MemberEntity) {
      return Member(
        points: entity.points,
        credits: entity.credits,
        coins: entity.coins,
      );
    } else {
      throw EntityModelMapperException(
        message: 'Entity should be of type MemberEntity',
      );
    }
  }
}
