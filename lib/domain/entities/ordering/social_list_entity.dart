import '../../domain.dart';

// Delivery Link entity

class SocialListEntity extends Entity<int> {
  final String? type;
  final String? url;
  final bool? isAllow;

  const SocialListEntity({required int id, this.type, this.url, this.isAllow})
    : super(id);

  @override
  List<Object?> get props => [id, type, url, isAllow];
}
