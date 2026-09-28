// Credit payment model

import '../../../../domain/domain.dart';

class CreditPaymentModel extends CreditPaymentEntity {
  const CreditPaymentModel({required super.id, super.qr, super.credits});

  factory CreditPaymentModel.fromJson(Map<String, dynamic> json) {
    return CreditPaymentModel(
      id: json['id'].toString(),
      qr: json['qr'] ?? '',
      credits: json['credits'] ?? '',
    );
  }
}
