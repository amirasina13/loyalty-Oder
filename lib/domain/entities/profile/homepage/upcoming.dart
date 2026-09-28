import '../../../domain.dart';

// Upcoming event list entity

class UpcomingEntity extends Entity<String> {
  final String? name;
  final String? image;
  final String? filterBy;
  final bool? isClickable;

  const UpcomingEntity({
    required String id,
    this.name,
    this.image,
    this.filterBy,
    this.isClickable,
  }) : super(id);

  @override
  List<Object?> get props => [id, name, image, filterBy, isClickable];
}
