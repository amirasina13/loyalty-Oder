import '../../../../domain/domain.dart';
import '../../../data.dart';

// Point records model (Will call in history_model.dart)

class RecordsModel extends RecordsEntity {
  const RecordsModel({required super.id, super.date, super.transaction});

  factory RecordsModel.fromJson(Map<String, dynamic> json) {
    List<TransactionModel> transaction = [];
    if (json['transactions'] != null) {
      for (var s in (json['transactions'] as List)) {
        {
          transaction.add(TransactionModel.fromJson(s));
        }
      }
    }

    return RecordsModel(id: '1', date: json['date'], transaction: transaction);
  }
}
