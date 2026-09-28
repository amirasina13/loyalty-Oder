import 'package:equatable/equatable.dart';

import '../../../domain/domain.dart';
import '../../data.dart';

/* 
  Equatable overrides == and hashCode for you so you don't have to waste your time writing lots of boilerplate code. 
  With Equatable there is no code generation needed.
  
  CLASS FOR NEARBY OUTLET
*/

class NearbyOutlet extends Equatable {
  final List<NearbyOutletList>? outlets;
  final String? next;

  const NearbyOutlet({this.outlets, this.next});

  @override
  List<Object?> get props => [outlets, next];

  @override
  factory NearbyOutlet.fromEntity(Entity entity) {
    if (entity is NearbyOutletEntity) {
      List<NearbyOutletList> outlets = [];
      entity.outlets?.forEach((s) {
        outlets.add(NearbyOutletList.fromEntity(s));
      });

      // // ignore: avoid_print
      // print('records model: $records');

      return NearbyOutlet(outlets: outlets, next: entity.next);
    } else {
      throw EntityModelMapperException(
        message: 'Entity should be of type NearbyOutletEntity',
      );
    }
  }
}
