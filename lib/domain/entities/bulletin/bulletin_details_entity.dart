import '../../domain.dart';

// Bulletin/ IF News details entity

class BulletinDetailsEntity extends Entity<String> {
  final String? name;
  final String? image;
  final String? button;
  final String? link;
  final String? content;
  final bool? isButton;

  const BulletinDetailsEntity({
    required String id,
    this.name,
    this.image,
    this.button,
    this.link,
    this.content,
    this.isButton,
  }) : super(id);

  @override
  List<Object?> get props => [id, name, image, button, link, content, isButton];
}
