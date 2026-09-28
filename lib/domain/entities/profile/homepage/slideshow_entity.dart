import '../../../domain.dart';

// Slideshow entity. Will call in home_page_entity.dart

class SlideshowEntity extends Entity<String> {
  final String? path;
  final String? url;

  const SlideshowEntity({required String id, this.path, this.url}) : super(id);

  @override
  List<Object?> get props => [id, path, url];
}
