import 'package:equatable/equatable.dart';

import '../../../domain/domain.dart';
import '../../data.dart';

/* 
  Equatable overrides == and hashCode for you so you don't have to waste your time writing lots of boilerplate code. 
  With Equatable there is no code generation needed.
  
  CLASS FOR BULLETIN LIST
*/

class Bulletin extends Equatable {
  final String? id;
  final String? name;
  final String? image;

  const Bulletin({this.id, this.name, this.image});

  @override
  List<Object?> get props => [id, name, image];

  @override
  factory Bulletin.fromEntity(Entity entity) {
    if (entity is BulletinEntity) {
      return Bulletin(id: entity.id, name: entity.name, image: entity.image);
    } else {
      throw EntityModelMapperException(
        message: 'Entity should be of type BulletinEntity',
      );
    }
  }
}
