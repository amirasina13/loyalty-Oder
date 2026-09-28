import 'package:equatable/equatable.dart';

import '../../../domain/domain.dart';
import '../../data.dart';

/* 
  Equatable overrides == and hashCode for you so you don't have to waste your time writing lots of boilerplate code. 
  With Equatable there is no code generation needed.
  
  CLASS FOR OPERATION OUTLET LIST (WILL CALL IN OUTLET_DETAILS.DART)
*/

class Operation extends Equatable {
  final String? day;
  final String? dayName;
  final String? start;
  final String? end;
  final String? sortby;

  const Operation({this.day, this.dayName, this.start, this.end, this.sortby});

  @override
  List<Object?> get props => [day, dayName, start, end, sortby];

  @override
  factory Operation.fromEntity(Entity entity) {
    if (entity is OperationEntity) {
      return Operation(
        day: entity.day,
        dayName: entity.dayName,
        start: entity.start,
        end: entity.end,
        sortby: entity.sortby,
      );
    } else {
      throw EntityModelMapperException(
        message: 'Entity should be of type OperationOutletEntity',
      );
    }
  }
}
