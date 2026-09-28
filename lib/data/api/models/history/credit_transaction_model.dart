import '../../../../domain/domain.dart';

// Credit transaction list model (will call in credit_record_model.dart)

class CreditTransactionModel extends CreditTransactionEntity {
  const CreditTransactionModel({
    required super.id,
    super.tranNo,
    super.tranDate,
    super.date,
    super.time,
    super.type,
    super.method,
    super.amount,
    super.desc,
  });

  factory CreditTransactionModel.fromJson(Map<String, dynamic> json) {
    return CreditTransactionModel(
      id: json['id'].toString(),
      tranNo: json['tranNo'] ?? '',
      tranDate: json['tranDate'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      type: json['type'] ?? '',
      method: json['method'] ?? '',
      amount: json['amount'] ?? '',
      desc: json['desc'] ?? '',
    );
  }
}
