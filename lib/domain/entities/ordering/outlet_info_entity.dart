import '../../domain.dart';

// Outlet info entity

class OutletInfoEntity extends Entity<String> {
  final MerchantInfoEntity? merchant;
  final List<OutletListEntity>? outlets;

  const OutletInfoEntity({required String id, this.merchant, this.outlets})
    : super(id);

  @override
  List<Object?> get props => [id, merchant, outlets];
}
