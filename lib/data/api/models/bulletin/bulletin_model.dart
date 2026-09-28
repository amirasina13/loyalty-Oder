// Bulletin List model

import '../../../../domain/domain.dart';

class BulletinModel extends BulletinEntity {
  const BulletinModel({required super.id, super.name, super.image});

  factory BulletinModel.fromJson(Map<String, dynamic> json) {
    return BulletinModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      image: json['image'] ?? '',
    );
  }
}
