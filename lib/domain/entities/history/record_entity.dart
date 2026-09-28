// Point records entity. Will call in history_entity.dart

import '../../domain.dart';

class RecordsEntity extends Entity<String> {
  final String? date;
  final List<TransactionEntity>? transaction;

  const RecordsEntity({required String id, this.date, this.transaction})
    : super(id);

  @override
  List<Object?> get props => [id, date, transaction];
}
