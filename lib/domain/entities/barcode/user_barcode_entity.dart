import '../../domain.dart';

// Qrcode for user entity

class UserQrcodeEntity extends Entity<String> {
  final ProfileBarcodeEntity? profile;
  final String? qr;
  final String? barcode;
  final String? codeString;

  const UserQrcodeEntity({
    required String id,
    this.profile,
    this.qr,
    this.barcode,
    this.codeString,
  }) : super(id);

  @override
  List<Object?> get props => [id, profile, qr, barcode, codeString];
}
