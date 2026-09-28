import 'package:equatable/equatable.dart';

import '../../../domain/domain.dart';
import '../../data.dart';

/* 
  Equatable overrides == and hashCode for you so you don't have to waste your time writing lots of boilerplate code. 
  With Equatable there is no code generation needed.
  
  CLASS FOR CREDIT HISTORY
*/

class CreditHistory extends Equatable {
  final List<CreditRecords>? records;
  final String? next;

  const CreditHistory({this.records, this.next});

  @override
  List<Object?> get props => [records, next];

  @override
  factory CreditHistory.fromEntity(Entity entity) {
    if (entity is CreditHistoryEntity) {
      List<CreditRecords> records = [];
      entity.records?.forEach((s) {
        records.add(CreditRecords.fromEntity(s));
      });

      return CreditHistory(records: records, next: entity.next);
    } else {
      throw EntityModelMapperException(
        message: 'Entity should be of type CreditHistoryEntity',
      );
    }
  }
}
