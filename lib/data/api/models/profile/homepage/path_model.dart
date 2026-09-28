import '../../../../../domain/domain.dart';

// Path model (will call in banners_model.dart)

class PathModel extends PathEntity {
  const PathModel({required super.id, super.type, super.path});

  factory PathModel.fromJson(Map<String, dynamic> json) {
    var index = 0;
    return PathModel(
      id: (index++).toString(),
      type: json['type'] ?? '',
      path: json['path'] ?? '',
    );
  }
}
