import 'package:equatable/equatable.dart';

import '../../../domain/domain.dart';
import '../../data.dart';

/* 
  Equatable overrides == and hashCode for you so you don't have to waste your time writing lots of boilerplate code. 
  With Equatable there is no code generation needed.
  
  CLASS FOR PERMISSIONS
*/

class Permissions extends Equatable {
  final bool? isMember;
  final bool? isVoucher;
  final bool? isPayment;
  final bool? isSubscription;

  const Permissions({
    this.isMember,
    this.isVoucher,
    this.isPayment,
    this.isSubscription,
  });

  @override
  List<Object?> get props => [isMember, isVoucher, isPayment, isSubscription];

  @override
  factory Permissions.fromEntity(Entity entity) {
    if (entity is PermissionsEntity) {
      return Permissions(
        isMember: entity.isMember,
        isVoucher: entity.isVoucher,
        isPayment: entity.isPayment,
        isSubscription: entity.isSubscription,
      );
    } else {
      throw EntityModelMapperException(
        message: 'Entity should be of type ListOutletEntity',
      );
    }
  }
}
