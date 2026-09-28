import '../../domain.dart';

// Point history entity

class NearbyOutletEntity extends Entity<String> {
  final List<NearbyOutletListEntity>? outlets;
  final String? next;

  const NearbyOutletEntity({required String id, this.outlets, this.next})
    : super(id);

  @override
  List<Object?> get props => [id, outlets, next];
}
