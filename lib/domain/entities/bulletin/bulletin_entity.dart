import '../../domain.dart';

// Bulletin/ IF News list entity. Also will call in home_page_entity.dart

class BulletinEntity extends Entity<String> {
  final String? name;
  final String? image;

  const BulletinEntity({required String id, this.name, this.image}) : super(id);

  @override
  List<Object?> get props => [id, name, image];
}
