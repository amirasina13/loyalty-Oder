import 'package:equatable/equatable.dart';

import '../../../domain/domain.dart';
import '../../data.dart';

/* 
  Equatable overrides == and hashCode for you so you don't have to waste your time writing lots of boilerplate code. 
  With Equatable there is no code generation needed.
  
  CLASS FOR BULLETIN DETAILS
*/

class BulletinDetails extends Equatable {
  final String? id;
  final String? name;
  final String? image;
  final String? button;
  final String? link;
  final String? content;
  final bool? isButton;

  const BulletinDetails({
    this.id,
    this.name,
    this.image,
    this.button,
    this.link,
    this.content,
    this.isButton,
  });

  @override
  List<Object?> get props => [id, name, image, button, link, content, isButton];

  @override
  factory BulletinDetails.fromEntity(Entity entity) {
    if (entity is BulletinDetailsEntity) {
      return BulletinDetails(
        id: entity.id,
        name: entity.name,
        image: entity.image,
        button: entity.button,
        link: entity.link,
        content: entity.content,
        isButton: entity.isButton,
      );
    } else {
      throw EntityModelMapperException(
        message: 'Entity should be of type BulletinDetailsEntity',
      );
    }
  }
}
