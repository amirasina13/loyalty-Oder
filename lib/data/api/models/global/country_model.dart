// Country model

import '../../../../domain/domain.dart';

class CountryModel extends CountryEntity {
  const CountryModel({
    required super.id,
    super.name,
    required String super.code,
    required String super.callCode,
    super.timezone,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      id: json['code'],
      name: json['name'],
      code: json['code'],
      callCode: json['callCode'],
      timezone: json['timezone'],
    );
  }
}
