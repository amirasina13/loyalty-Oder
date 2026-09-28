// Bulletin Details model

import '../../../../domain/domain.dart';

class BulletinDetailsModel extends BulletinDetailsEntity {
  const BulletinDetailsModel({
    required super.id,
    super.name,
    super.image,
    super.button,
    super.link,
    super.content,
    super.isButton,
  });

  factory BulletinDetailsModel.fromJson(Map<String, dynamic> json) {
    return BulletinDetailsModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      button: json['button'] ?? '',
      link: json['link'] ?? '',
      content: json['content'] ?? '',
      isButton: json['isButton'] ?? '',
    );
  }
}
