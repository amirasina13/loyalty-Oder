import '../../../domain.dart';

// Banners entity. Will call in home_page_entity.dart

class BannersEntity extends Entity<String> {
  final bool? isShow;
  final List<PathEntity>? path;

  const BannersEntity({required String id, this.isShow, this.path}) : super(id);

  @override
  List<Object?> get props => [id, isShow, path];
}
