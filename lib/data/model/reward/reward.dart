import 'package:equatable/equatable.dart';

import '../../../domain/domain.dart';
import '../../data.dart';

/* 
  Equatable overrides == and hashCode for you so you don't have to waste your time writing lots of boilerplate code. 
  With Equatable there is no code generation needed.
  
  CLASS FOR IF PERKS LIST DETAILS. WILL CALL IN REWARD_DATA.DART
*/

class Reward extends Equatable {
  final String? id;
  final String? image;
  final String? name;
  final String? desc;
  final bool? isPoint;
  final String? points;
  final bool? isCredit;
  final String? credits;
  final bool? isMuslim;
  final String? muslimCategory;
  final bool? isDiscount;
  final String? aftDisPoints;
  final String? aftDisCredits;

  const Reward({
    this.id,
    this.image,
    this.name,
    this.desc,
    this.isPoint,
    this.points,
    this.isCredit,
    this.credits,
    this.isMuslim,
    this.muslimCategory,
    this.isDiscount,
    this.aftDisPoints,
    this.aftDisCredits,
  });

  @override
  List<Object?> get props => [
    id,
    image,
    name,
    desc,
    isPoint,
    points,
    isCredit,
    credits,
    isMuslim,
    muslimCategory,
    isDiscount,
    aftDisPoints,
    aftDisCredits,
  ];

  @override
  factory Reward.fromEntity(Entity entity) {
    if (entity is RewardEntity) {
      return Reward(
        id: entity.id,
        image: entity.image,
        name: entity.name,
        desc: entity.desc,
        isPoint: entity.isPoint,
        points: entity.points,
        isCredit: entity.isCredit,
        credits: entity.credits,
        isMuslim: entity.isMuslim,
        muslimCategory: entity.muslimCategory,
        isDiscount: entity.isDiscount,
        aftDisPoints: entity.aftDisPoints,
        aftDisCredits: entity.aftDisCredits,
      );
    } else {
      throw EntityModelMapperException(
        message: 'Entity should be of type RewardEntity',
      );
    }
  }
}
