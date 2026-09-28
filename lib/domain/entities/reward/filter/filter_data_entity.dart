import '../../../domain.dart';

// Reward/ IF Perks details entity

class FilterDataEntity extends Entity<String> {
  final String? title;
  final List<OptionsCategoryEntity>? options;
  final String? input;

  const FilterDataEntity({
    required String id,
    this.title,
    this.options,
    this.input,
  }) : super(id);

  @override
  List<Object?> get props => [id, title, options, input];
}
