// Merchant list model

import '../../../../domain/domain.dart';

class DeliveryLinkModel extends DeliveryLinkEntity {
  const DeliveryLinkModel({
    required super.id,
    super.type,
    super.url,
    final bool? isAllow,
  });

  factory DeliveryLinkModel.fromJson(Map<String, dynamic> json) {
    return DeliveryLinkModel(
      id: 0,
      type: json['type'] ?? '',
      url: json['url'] ?? '',
    );
  }
}
