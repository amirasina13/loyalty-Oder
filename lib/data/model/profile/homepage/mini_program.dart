import 'package:equatable/equatable.dart';

import '../../../../domain/domain.dart';
import '../../../data.dart';

/* 
  Equatable overrides == and hashCode for you so you don't have to waste your time writing lots of boilerplate code. 
  With Equatable there is no code generation needed.
  
  CLASS FOR HOMEPAGE MINI PROGRAM
*/

class MiniProgram extends Equatable {
  final String? id;
  final String? name;
  final String? image;
  final String? url;
  final String? appId;
  final String? isVerified;

  const MiniProgram({
    this.id,
    this.name,
    this.image,
    this.url,
    this.appId,
    this.isVerified,
  });

  @override
  List<Object?> get props => [id, name, image, url, appId, isVerified];

  @override
  factory MiniProgram.fromEntity(Entity entity) {
    if (entity is MiniProgramEntity) {
      return MiniProgram(
        id: entity.id,
        name: entity.name,
        image: entity.image,
        url: entity.url,
        appId: entity.appId,
        isVerified: entity.isVerified,
      );
    } else {
      throw EntityModelMapperException(
        message: 'Entity should be of type MiniProgramEntity',
      );
    }
  }
}
