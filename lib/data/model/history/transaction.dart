import 'package:equatable/equatable.dart';

import '../../../domain/domain.dart';
import '../../data.dart';

/* 
  Equatable overrides == and hashCode for you so you don't have to waste your time writing lots of boilerplate code. 
  With Equatable there is no code generation needed.
  
  CLASS FOR POINT TRANSACTION (WILL CALL IN RECORDS.DART)
*/

class Transaction extends Equatable {
  final String? id;
  final String? tranNo;
  final String? tranDate;
  final String? date;
  final String? time;
  final String? type;
  final String? method;
  final String? points;
  final String? desc;

  const Transaction({
    this.id,
    this.tranNo,
    this.tranDate,
    this.date,
    this.time,
    this.type,
    this.method,
    this.points,
    this.desc,
  });

  @override
  List<Object?> get props => [
    id,
    tranNo,
    tranDate,
    date,
    time,
    type,
    method,
    points,
    desc,
  ];

  @override
  factory Transaction.fromEntity(Entity entity) {
    if (entity is TransactionEntity) {
      return Transaction(
        id: entity.id,
        tranNo: entity.tranNo,
        tranDate: entity.tranDate,
        date: entity.date,
        time: entity.time,
        type: entity.type,
        method: entity.method,
        points: entity.points,
        desc: entity.desc,
      );
    } else {
      throw EntityModelMapperException(
        message: 'Entity should be of type TransactionEntity',
      );
    }
  }
}
