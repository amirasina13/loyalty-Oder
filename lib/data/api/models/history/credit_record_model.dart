// Credits records model (will call in credit_history_model.dart)

import '../../../../domain/domain.dart';
import '../../../data.dart';

class CreditRecordsModel extends CreditRecordsEntity {
  const CreditRecordsModel({required super.id, super.date, super.transaction});

  factory CreditRecordsModel.fromJson(Map<String, dynamic> json) {
    List<CreditTransactionModel> transaction = [];
    if (json['transactions'] != null) {
      for (var s in (json['transactions'] as List)) {
        {
          transaction.add(CreditTransactionModel.fromJson(s));
        }
      }
    }

    return CreditRecordsModel(
      id: '1',
      date: json['date'],
      transaction: transaction,
    );
  }
}
