import '../../../../domain/domain.dart';

// OperaTion list model (will call in outlet_details_model.dart)

class OperationModel extends OperationEntity {
  const OperationModel({
    required super.id,
    super.day,
    super.dayName,
    super.start,
    super.end,
    super.sortby,
  });

  factory OperationModel.fromJson(Map<String, dynamic> json) {
    return OperationModel(
      id: json['sortby'].toString(),
      day: json['day'] ?? '',
      dayName: json['dayName'] ?? '',
      start: json['start'] ?? '',
      end: json['end'] ?? '',
      sortby: json['sortby'] ?? '',
    );
  }
}
