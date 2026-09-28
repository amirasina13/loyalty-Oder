import 'package:equatable/equatable.dart';

import '../../../domain/domain.dart';
import '../../data.dart';

/* 
  Equatable overrides == and hashCode for you so you don't have to waste your time writing lots of boilerplate code. 
  With Equatable there is no code generation needed.
  
  CLASS FOR SOCIAL LIST
*/

class SocialList extends Equatable {
  final String? type;
  final String? url;

  const SocialList({this.type, this.url});

  @override
  List<Object?> get props => [type, url];

  @override
  factory SocialList.fromEntity(Entity entity) {
    if (entity is SocialListEntity) {
      return SocialList(type: entity.type, url: entity.url);
    } else {
      throw EntityModelMapperException(
        message: 'Entity should be of type SocialListEntity',
      );
    }
  }
}
