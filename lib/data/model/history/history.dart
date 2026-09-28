import 'package:equatable/equatable.dart';

import '../../../domain/domain.dart';
import '../../data.dart';

/* 
  Equatable overrides == and hashCode for you so you don't have to waste your time writing lots of boilerplate code. 
  With Equatable there is no code generation needed.
  
  CLASS FOR POINT HISTORY
*/

class History extends Equatable {
  final List<Records>? records;
  final String? next;

  const History({this.records, this.next});

  @override
  List<Object?> get props => [records, next];

  @override
  factory History.fromEntity(Entity entity) {
    if (entity is HistoryEntity) {
      List<Records> records = [];
      entity.records?.forEach((s) {
        records.add(Records.fromEntity(s));
      });

      // // ignore: avoid_print
      // print('records model: $records');

      return History(records: records, next: entity.next);
    } else {
      throw EntityModelMapperException(
        message: 'Entity should be of type HistoryEntity',
      );
    }
  }
}
