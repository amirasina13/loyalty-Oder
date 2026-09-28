import 'package:equatable/equatable.dart';

import '../../../domain/domain.dart';
import '../../data.dart';

/* 
  Equatable overrides == and hashCode for you so you don't have to waste your time writing lots of boilerplate code. 
  With Equatable there is no code generation needed.
  
  CLASS FOR CREDIT TRANSACTION DETAILS (WILL CALL IN CREDIT_RECODS.DART)
*/

class CreditTransaction extends Equatable {
  final String? id;
  final String? tranNo;
  final String? tranDate;
  final String? date;
  final String? time;
  final String? type;
  final String? method;
  final String? amount;
  final String? desc;

  const CreditTransaction({
    this.id,
    this.tranNo,
    this.tranDate,
    this.date,
    this.time,
    this.type,
    this.method,
    this.amount,
    this.desc,
  });

  @override
  List<Object?> get props => [
    id,
    tranNo,
    tranDate,
    date,
    time,
    type,
    method,
    amount,
    desc,
  ];

  @override
  factory CreditTransaction.fromEntity(Entity entity) {
    if (entity is CreditTransactionEntity) {
      return CreditTransaction(
        id: entity.id,
        tranNo: entity.tranNo,
        tranDate: entity.tranDate,
        date: entity.date,
        time: entity.time,
        type: entity.type,
        method: entity.method,
        amount: entity.amount,
        desc: entity.desc,
      );
    } else {
      throw EntityModelMapperException(
        message: 'Entity should be of type CreditTransactionEntity',
      );
    }
  }
}
