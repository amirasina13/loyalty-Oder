import 'package:equatable/equatable.dart';

import '../../../../domain/domain.dart';
import '../../../data.dart';

/* 
  Equatable overrides == and hashCode for you so you don't have to waste your time writing lots of boilerplate code. 
  With Equatable there is no code generation needed.
  
  CLASS FOR BANNERS ANNOUNCEMENT. WILL CALL IN HOME_PAGE.DART
*/

class Banners extends Equatable {
  final bool? isShow;
  final List<Path>? path;

  const Banners({this.isShow, this.path});

  @override
  List<Object?> get props => [isShow, path];

  @override
  factory Banners.fromEntity(Entity entity) {
    if (entity is BannersEntity) {
      List<Path> path = [];
      entity.path?.forEach((s) {
        path.add(Path.fromEntity(s));
      });

      return Banners(isShow: entity.isShow, path: path);
    } else {
      throw EntityModelMapperException(
        message: 'Entity should be of type PointsEntity',
      );
    }
  }
}
