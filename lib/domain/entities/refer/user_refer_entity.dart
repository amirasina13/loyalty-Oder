import '../../domain.dart';

// User referral entity

class UserReferEntity extends Entity<String> {
  final String? code;
  final String? link;
  final String? qr;
  final String? barcode;
  final String? codeString;
  final String? text;

  const UserReferEntity({
    required String id,
    this.code,
    this.link,
    this.qr,
    this.barcode,
    this.codeString,
    this.text,
  }) : super(id);

  @override
  List<Object?> get props => [id, code, link, qr, barcode, codeString, text];
}
