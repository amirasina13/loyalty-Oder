import 'package:equatable/equatable.dart';

import '../../../../domain/domain.dart';
import '../../../data.dart';

/* 
  Equatable overrides == and hashCode for you so you don't have to waste your time writing lots of boilerplate code. 
  With Equatable there is no code generation needed.
  
  CLASS FOR SLIDESHOW IMAGE. WILL CALL IN HOME_PAGE.DART
*/

class Slideshow extends Equatable {
  final String? path;
  final String? url;

  const Slideshow({this.path, this.url});

  /// Helper getter so your UI always gets a usable image string safely
  String get displayUrl => (path?.isNotEmpty ?? false) ? path! : (url ?? '');

  @override
  List<Object?> get props => [path, url];

  @override
  factory Slideshow.fromEntity(Entity entity) {
    if (entity is SlideshowEntity) {
      return Slideshow(path: entity.path, url: entity.url);
    } else {
      throw EntityModelMapperException(
        message: 'Entity should be of type PointsEntity',
      );
    }
  }
}
