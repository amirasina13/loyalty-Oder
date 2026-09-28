import '../../../domain.dart';

// Path entity. Will call in banners_entity.dart

class PathEntity extends Entity<String> {
  final String? type;
  final String? path;

  const PathEntity({required String id, this.type, this.path}) : super(id);

  @override
  List<Object?> get props => [id, type, path];
}
