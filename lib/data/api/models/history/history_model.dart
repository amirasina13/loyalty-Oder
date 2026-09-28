import '../../../../domain/domain.dart';
import '../../../data.dart';

// Point history model

class HistoryModel extends HistoryEntity {
  const HistoryModel({
    required super.id,
    List<RecordsModel>? super.records,
    super.next,
  });

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    List<RecordsModel> records = [];
    if (json['records'] != null) {
      for (var s in (json['records'] as List)) {
        {
          records.add(RecordsModel.fromJson(s));
        }
      }
    }

    return HistoryModel(id: '1', records: records, next: json['next']);
  }
}
