import '../../../domain.dart';

// Mini Program list entity

class MiniProgramEntity extends Entity<String> {
  final String? name;
  final String? image;
  final String? filterBy;
  final String? url;
  final String? appId;
  final String? isVerified;

  const MiniProgramEntity({
    required String id,
    this.name,
    this.image,
    this.filterBy,
    this.url,
    this.appId,
    this.isVerified,
  }) : super(id);

  @override
  List<Object?> get props => [
    id,
    name,
    image,
    filterBy,
    url,
    appId,
    isVerified,
  ];
}
