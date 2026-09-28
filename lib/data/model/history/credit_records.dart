import 'package:equatable/equatable.dart';

import '../../../domain/domain.dart';
import '../../data.dart';

/* 
  Equatable overrides == and hashCode for you so you don't have to waste your time writing lots of boilerplate code. 
  With Equatable there is no code generation needed.
  
  CLASS FOR CREDIT RECORDS (WILL CALL IN CREDIT_HISTORY.DART)
*/

class CreditRecords extends Equatable {
  final String? date;
  final List<CreditTransaction>? transaction;

  const CreditRecords({this.date, this.transaction});

  @override
  List<Object?> get props => [date, transaction];

  @override
  factory CreditRecords.fromEntity(Entity entity) {
    if (entity is CreditRecordsEntity) {
      List<CreditTransaction> transaction = [];
      entity.transaction?.forEach((s) {
        transaction.add(CreditTransaction.fromEntity(s));
      });

      return CreditRecords(date: entity.date, transaction: transaction);
    } else {
      throw EntityModelMapperException(
        message: 'Entity should be of type CreditRecordsEntity',
      );
    }
  }
}
