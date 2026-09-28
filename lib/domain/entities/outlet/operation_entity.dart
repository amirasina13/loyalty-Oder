import '../../domain.dart';

// Operation outlet entity. Will call in outlet_details_entity.dart

class OperationEntity extends Entity<String> {
  final String? day;
  final String? dayName;
  final String? start;
  final String? end;
  final String? sortby;

  const OperationEntity({
    required String id,
    this.day,
    this.dayName,
    this.start,
    this.end,
    this.sortby,
  }) : super(id);

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'day': day,
      'dayName': dayName,
      'start': start,
      'end': end,
      'sortby': sortby,
    };
  }

  @override
  List<Object?> get props => [id, day, dayName, start, end, sortby];
}
