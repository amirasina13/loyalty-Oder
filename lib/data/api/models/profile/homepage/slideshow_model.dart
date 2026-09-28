import '../../../../../domain/domain.dart';

// Slideshoe model (will call in home_page_model.dart)

class SlideshowModel extends SlideshowEntity {
  const SlideshowModel({required super.id, super.path, super.url});

  factory SlideshowModel.fromJson(dynamic json) {
    if (json is String) {
      return SlideshowModel(id: '', path: json, url: '');
    }
    if (json is Map<String, dynamic>) {
      return SlideshowModel(
        id: json['id']?.toString() ?? '',
        path: json['path'] as String? ?? json['image'] as String?,
        url: json['url'] as String? ?? '',
      );
    }
    return const SlideshowModel(id: '', path: '', url: '');
  }

  // factory SlideshowModel.fromJson(Map<String, dynamic> json) {
  //   var index = 0;

  //   return SlideshowModel(
  //     id: (index++).toString(),
  //     path: json['path'],
  //     url: json['url'],
  //   );
  // }
}
