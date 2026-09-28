import '../../../../domain/domain.dart';

// Point transaction List model (Will call in record_model.dart)

class TransactionModel extends TransactionEntity {
  const TransactionModel({
    required super.id,
    super.tranNo,
    super.tranDate,
    super.date,
    super.time,
    super.type,
    super.method,
    super.points,
    super.desc,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'].toString(),
      tranNo: json['tranNo'] ?? '',
      tranDate: json['tranDate'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      type: json['type'] ?? '',
      method: json['method'] ?? '',
      points: json['points'] ?? '',
      desc: json['desc'] ?? '',
    );
  }
}
