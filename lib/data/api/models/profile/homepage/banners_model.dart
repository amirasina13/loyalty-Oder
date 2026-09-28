import '../../../../../domain/domain.dart';
import '../../../../data.dart';

// Banners model (will call in home_page_model.dart)

class BannersModel extends BannersEntity {
  const BannersModel({
    required super.id,
    super.isShow,
    List<PathModel>? super.path,
  });

  factory BannersModel.fromJson(Map<String, dynamic> json) {
    var index = 0;

    List<PathModel> path = [];
    if (json['path'] != null) {
      for (var s in (json['path'] as List)) {
        {
          path.add(PathModel.fromJson(s));
        }
      }
    }

    return BannersModel(
      id: (index++).toString(),
      isShow: json['isShow'],
      path: path,
    );
  }
}
