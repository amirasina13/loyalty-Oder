import '../../domain.dart';

// Credit transaction entity. will call in credit_record_entity.dart

class CreditTransactionEntity extends Entity<String> {
  final String? tranNo;
  final String? tranDate;
  final String? date;
  final String? time;
  final String? type;
  final String? method;
  final String? amount;
  final String? desc;

  const CreditTransactionEntity({
    required String id,
    this.tranNo,
    this.tranDate,
    this.date,
    this.time,
    this.type,
    this.method,
    this.amount,
    this.desc,
  }) : super(id);

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
}
