import '../../../../domain/domain.dart';

// User referral code model

class UserReferModel extends UserReferEntity {
  const UserReferModel({
    required super.id,
    super.code,
    super.link,
    super.qr,
    super.barcode,
    super.codeString,
    super.text,
  });

  factory UserReferModel.fromJson(Map<String, dynamic> json) {
    return UserReferModel(
      id: json['code'].toString(),
      code: json['code'],
      link: json['link'],
      qr: json['qr'],
      barcode: json['barcode'],
      codeString: json['codeString'],
      text: json['text'],
    );
  }
}
