import 'package:equatable/equatable.dart';

import '../../../domain/domain.dart';
import '../../data.dart';

/* 
  Equatable overrides == and hashCode for you so you don't have to waste your time writing lots of boilerplate code. 
  With Equatable there is no code generation needed.
  
  CLASS FOR IF PERKS DETAILS
*/

class DetailsData extends Equatable {
  final Member? member;
  final Details? voucher;
  final List<RewardOutlet>? outlets;

  const DetailsData({this.member, this.voucher, this.outlets});

  @override
  List<Object?> get props => [member, voucher, outlets];

  @override
  factory DetailsData.fromEntity(Entity entity) {
    if (entity is DetailsDataEntity) {
      List<RewardOutlet> outlets = [];
      entity.outlets?.forEach((s) {
        outlets.add(RewardOutlet.fromEntity(s));
      });

      return DetailsData(
        member: Member.fromEntity(entity.member!),
        voucher: Details.fromEntity(entity.voucher!),
        outlets: outlets,
      );
    } else {
      throw EntityModelMapperException(
        message: 'Entity should be of type RewardDataEntity',
      );
    }
  }
}
