import 'package:equatable/equatable.dart';

import '../../../../domain/domain.dart';
import '../../../data.dart';

/* 
  Equatable overrides == and hashCode for you so you don't have to waste your time writing lots of boilerplate code. 
  With Equatable there is no code generation needed.
  
  CLASS FOR HOMEPAGE UPCOMING
*/

class Upcoming extends Equatable {
  final String? id;
  final String? name;
  final String? image;
  final bool? isClickable;

  const Upcoming({this.id, this.name, this.image, this.isClickable});

  @override
  List<Object?> get props => [id, name, image, isClickable];

  @override
  factory Upcoming.fromEntity(Entity entity) {
    if (entity is UpcomingEntity) {
      return Upcoming(
        id: entity.id,
        name: entity.name,
        image: entity.image,
        isClickable: entity.isClickable,
      );
    } else {
      throw EntityModelMapperException(
        message: 'Entity should be of type UpcomingEntity',
      );
    }
  }
}
