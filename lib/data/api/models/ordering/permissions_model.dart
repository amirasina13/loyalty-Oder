import '../../../../domain/domain.dart';

// Permissions model

class PermissionsModel extends PermissionsEntity {
  const PermissionsModel({
    required super.id,
    super.isMember,
    super.isVoucher,
    super.isPayment,
    super.isSubscription,
  });

  factory PermissionsModel.fromJson(Map<String, dynamic> json) {
    return PermissionsModel(
      id: 0,
      isMember: json['isMember'] ?? '',
      isVoucher: json['isVoucher'] ?? '',
      isPayment: json['isPayment'] ?? '',
      isSubscription: json['isSubscription'] ?? 0,
    );
  }
}
