import 'package:equatable/equatable.dart';

import '../../../domain/domain.dart';
import '../../data.dart';

/* 
  Equatable overrides == and hashCode for you so you don't have to waste your time writing lots of boilerplate code. 
  With Equatable there is no code generation needed.
  
  CLASS FOR OUTLET INFORMATION
*/

class OutletInfo extends Equatable {
  final MerchantInfo? merchant;
  final List<OutletList>? outlets;

  const OutletInfo({this.merchant, this.outlets});

  @override
  List<Object?> get props => [merchant, outlets];

  @override
  factory OutletInfo.fromEntity(Entity entity) {
    if (entity is OutletInfoEntity) {
      List<OutletList> outlets = [];
      entity.outlets?.forEach((s) {
        outlets.add(OutletList.fromEntity(s));
      });

      // // ignore: avoid_print
      // print('records model: $records');

      return OutletInfo(
        merchant: MerchantInfo.fromEntity(entity.merchant!),
        outlets: outlets,
      );
    } else {
      throw EntityModelMapperException(
        message: 'Entity should be of type OutletInfoEntity',
      );
    }
  }
}
