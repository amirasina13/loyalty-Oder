import '../../../../domain/domain.dart';
import '../../../data.dart';

// Voucher details model

class VoucherDetailsModel extends VoucherDetailsEntity {
  const VoucherDetailsModel({
    required super.id,
    super.voucherId,
    super.image,
    super.type,
    super.name,
    super.desc,
    super.code,
    super.expired,
    super.isMuslim,
    super.muslimCategory,
    super.purchaseMethod,
    super.redeemMethod,
    super.tnc,
    super.voucherType,
    super.share,
    super.shareLink,
    super.qr,
    super.barcode,
    super.outlets,
  });

  factory VoucherDetailsModel.fromJson(Map<String, dynamic> json) {
    List<RewardOutletModel> outlets = [];
    if (json['outlets'] != null) {
      for (var s in (json['outlets'] as List)) {
        {
          outlets.add(RewardOutletModel.fromJson(s));
        }
      }
    }

    return VoucherDetailsModel(
      id: json['id'].toString(),
      voucherId: json['voucherId'].toString(),
      image: json['image'] ?? '',
      type: json['type'] ?? '',
      name: json['name'] ?? '',
      desc: json['desc'] ?? '',
      code: json['code'] ?? '',
      expired: json['expired'] ?? '',
      isMuslim: json['isMuslim'],
      muslimCategory: json['muslimCategory'] ?? '',
      purchaseMethod: json['purchaseMethod'],
      redeemMethod: json['redeemMethod'],
      tnc: json['tnc'] ?? '',
      voucherType: json['voucherType'] ?? '',
      share: json['share'] ?? '',
      shareLink: json['share_link'] ?? '',
      qr: json['qr'] ?? '',
      barcode: json['barcode'] ?? '',
      outlets: outlets,
    );
  }
}
