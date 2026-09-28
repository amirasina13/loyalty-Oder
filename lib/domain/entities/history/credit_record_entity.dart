import '../../domain.dart';

// Credit Records entity. Will call im credit_history_entity.dart

class CreditRecordsEntity extends Entity<String> {
  final String? date;
  final List<CreditTransactionEntity>? transaction;

  const CreditRecordsEntity({required String id, this.date, this.transaction})
    : super(id);

  @override
  List<Object?> get props => [id, date, transaction];
}
