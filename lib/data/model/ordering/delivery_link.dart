import 'package:equatable/equatable.dart';

import '../../../domain/domain.dart';
import '../../data.dart';

/* 
  Equatable overrides == and hashCode for you so you don't have to waste your time writing lots of boilerplate code. 
  With Equatable there is no code generation needed.
  
  CLASS FOR DELIVERY LINK
*/

class DeliveryLink extends Equatable {
  final String? type;
  final String? url;
  // final bool? isAllow;

  const DeliveryLink({
    this.type,
    this.url,
    // this.isAllow,
  });

  @override
  List<Object?> get props => [
    type,
    url,
    // isAllow,
  ];

  @override
  factory DeliveryLink.fromEntity(Entity entity) {
    if (entity is DeliveryLinkEntity) {
      return DeliveryLink(
        type: entity.type,
        url: entity.url,
        // isAllow: entity.isAllow,
      );
    } else {
      throw EntityModelMapperException(
        message: 'Entity should be of type DeliveryLinkEntity',
      );
    }
  }
}
