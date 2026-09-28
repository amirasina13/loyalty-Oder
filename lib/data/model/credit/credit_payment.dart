import 'package:equatable/equatable.dart';

import '../../../domain/domain.dart';
import '../../data.dart';

/* 
  Equatable overrides == and hashCode for you so you don't have to waste your time writing lots of boilerplate code. 
  With Equatable there is no code generation needed.
  
  CLASS FOR CREDIT PAYMENT DETAILS
*/

class CreditPayment extends Equatable {
  final String? qr;
  final String? credits;

  const CreditPayment({this.qr, this.credits});

  @override
  List<Object?> get props => [qr, credits];

  @override
  factory CreditPayment.fromEntity(Entity entity) {
    if (entity is CreditPaymentEntity) {
      return CreditPayment(qr: entity.qr, credits: entity.credits);
    } else {
      throw EntityModelMapperException(
        message: 'Entity should be of type CreditDetailsEntity',
      );
    }
  }
}
