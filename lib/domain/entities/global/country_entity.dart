import '../../domain.dart';

// Country code entity

class CountryEntity extends Entity<String> {
  final String? name;
  final String? code;
  final String? callCode;
  final String? timezone;

  const CountryEntity({
    required String id,
    this.name,
    this.code = 'MY',
    this.callCode = '60',
    this.timezone,
  }) : super(id);

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': code,
      'name': name,
      'code': code,
      'callCode': callCode,
      'timezone': timezone,
    };
  }

  @override
  List<Object?> get props => [id, name, code, callCode, timezone];
}
