import '../../../../domain/domain.dart';
import '../../../data.dart';

// User member card model

class UserMembercardeModel extends UserQrcodeEntity {
  const UserMembercardeModel({
    required super.id,
    ProfileBarcodeModel? super.profile,
    super.qr,
    super.barcode,
    super.codeString,
  });

  factory UserMembercardeModel.fromJson(Map<String, dynamic> json) {
    var profile = ProfileBarcodeModel.fromJson(json['profile']);

    return UserMembercardeModel(
      id: profile.id.toString(),
      profile: profile,
      qr: json['qr'] ?? '',
      barcode: json['barcode'] ?? '',
      codeString: json['codeString'] ?? '',
    );
  }
}
