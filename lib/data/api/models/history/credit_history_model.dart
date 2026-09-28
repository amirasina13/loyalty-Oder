import '../../../../domain/domain.dart';
import '../../../data.dart';

// Credit history model
class CreditHistoryModel extends CreditHistoryEntity {
  const CreditHistoryModel({required super.id, super.records, super.next});

  factory CreditHistoryModel.fromJson(Map<String, dynamic> json) {
    List<CreditRecordsModel> records = [];
    if (json['records'] != null) {
      for (var s in (json['records'] as List)) {
        {
          records.add(CreditRecordsModel.fromJson(s));
        }
      }
    }

    return CreditHistoryModel(id: '1', records: records, next: json['next']);
  }
}
