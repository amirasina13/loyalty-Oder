import '../../../domain.dart';

// Options Category entity

class OptionsCategoryEntity extends Entity<String> {
  final String? name;
  final String? image;
  final String? filterBy;

  const OptionsCategoryEntity({
    required String id,
    this.name,
    this.image,
    this.filterBy,
  }) : super(id);

  @override
  List<Object?> get props => [id, name, image, filterBy];
}
