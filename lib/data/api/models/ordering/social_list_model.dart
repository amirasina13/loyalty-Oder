import '../../../../domain/domain.dart';

// Social list model

class SocialListModel extends SocialListEntity {
  const SocialListModel({required super.id, super.type, super.url});

  factory SocialListModel.fromJson(Map<String, dynamic> json) {
    // List<SocialListModel> external = [];

    return SocialListModel(
      id: 0,
      type: json['type'] ?? '',
      url: json['url'] ?? '',
    );
  }
}
