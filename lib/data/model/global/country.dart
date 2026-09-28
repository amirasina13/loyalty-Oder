import 'package:equatable/equatable.dart';

import '../../../domain/domain.dart';
import '../../data.dart';

/* 
  Equatable overrides == and hashCode for you so you don't have to waste your time writing lots of boilerplate code. 
  With Equatable there is no code generation needed.
  
  CLASS FOR GET COUNTRY MOBILE CODE
*/

class Country extends Equatable {
  final String? name;
  final String? code;
  final String? callCode;
  final String? timezone;

  const Country({this.name, this.code, this.callCode, this.timezone});

  @override
  List<Object?> get props => [name, code, callCode, timezone];

  @override
  bool get stringify => true;

  @override
  factory Country.fromEntity(Entity entity) {
    if (entity is CountryEntity) {
      return Country(
        name: entity.name,
        code: entity.code,
        callCode: entity.callCode,
        timezone: entity.timezone,
      );
    } else {
      throw EntityModelMapperException(
        message: 'Entity should be of type CountryEntity',
      );
    }
  }
}
