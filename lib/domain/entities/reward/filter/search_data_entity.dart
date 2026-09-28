import '../../../domain.dart';

// Reward/ IF Perks details entity

class SearchDataEntity extends Entity<String> {
  final String? title;
  final List<SearchListEntity>? lists;

  const SearchDataEntity({this.title, this.lists}) : super('');

  @override
  List<Object?> get props => [title, lists];
}
