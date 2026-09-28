import 'package:equatable/equatable.dart';

import '../../../domain/domain.dart';
import '../../data.dart';

/* 
  Equatable overrides == and hashCode for you so you don't have to waste your time writing lots of boilerplate code. 
  With Equatable there is no code generation needed.
  
  CLASS FOR BANNER PATH. WILL CALL IN BANNER.DART
*/

class Path extends Equatable {
  final String? type;
  final String? path;

  const Path({this.type, this.path});

  @override
  List<Object?> get props => [type, path];

  @override
  factory Path.fromEntity(Entity entity) {
    if (entity is PathEntity) {
      return Path(type: entity.type, path: entity.path);
    } else {
      throw EntityModelMapperException(
        message: 'Entity should be of type PathEntity',
      );
    }
  }
}
