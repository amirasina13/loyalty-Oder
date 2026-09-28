import '../../../../domain/domain.dart';
import '../../../data.dart';

// Point history model

class NearbyOutletModel extends NearbyOutletEntity {
  const NearbyOutletModel({
    required super.id,
    List<NearbyOutletListModel>? super.outlets,
    super.next,
  });

  factory NearbyOutletModel.fromJson(Map<String, dynamic> json) {
    List<NearbyOutletListModel> outlets = [];
    if (json['outlets'] != null) {
      for (var s in (json['outlets'] as List)) {
        {
          outlets.add(NearbyOutletListModel.fromJson(s));
        }
      }
    }

    return NearbyOutletModel(id: '1', outlets: outlets, next: json['next']);
  }
}
