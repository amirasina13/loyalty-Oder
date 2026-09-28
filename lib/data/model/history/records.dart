import 'package:equatable/equatable.dart';

import '../../../domain/domain.dart';
import '../../data.dart';

/* 
  Equatable overrides == and hashCode for you so you don't have to waste your time writing lots of boilerplate code. 
  With Equatable there is no code generation needed.
  
  CLASS FOR POINT RECORDS (WILL CALL IN HISTORY.DART)
*/

class Records extends Equatable {
  final String? date;
  final List<Transaction>? transaction;

  const Records({this.date, this.transaction});

  @override
  List<Object?> get props => [date, transaction];

  @override
  factory Records.fromEntity(Entity entity) {
    if (entity is RecordsEntity) {
      List<Transaction> transaction = [];
      entity.transaction?.forEach((s) {
        transaction.add(Transaction.fromEntity(s));
      });

      return Records(date: entity.date, transaction: transaction);
    } else {
      throw EntityModelMapperException(
        message: 'Entity should be of type RecordsEntity',
      );
    }
  }
}
