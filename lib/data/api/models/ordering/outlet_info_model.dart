import '../../../../domain/domain.dart';
import '../../../data.dart';

// Point history model

class OutletInfoModel extends OutletInfoEntity {
  const OutletInfoModel({
    required super.id,
    MerchantInfoModel? super.merchant,
    List<OutletListModel>? super.outlets,
  });

  factory OutletInfoModel.fromJson(Map<String, dynamic> json) {
    List<OutletListModel> outlets = [];
    if (json['outlets'] != null) {
      for (var s in (json['outlets'] as List)) {
        {
          outlets.add(OutletListModel.fromJson(s));
        }
      }
    }

    return OutletInfoModel(
      id: '1',
      merchant: MerchantInfoModel.fromJson(json['merchant']),
      outlets: outlets,
    );
  }
}
