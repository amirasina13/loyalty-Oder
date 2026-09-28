import '../../domain.dart';

// Credit history entity

class CreditHistoryEntity extends Entity<String> {
  final List<CreditRecordsEntity>? records;
  final String? next;

  const CreditHistoryEntity({required String id, this.records, this.next})
    : super(id);

  @override
  List<Object?> get props => [id, records, next];
}
