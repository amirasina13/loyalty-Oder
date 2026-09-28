import '../../domain.dart';

// Categories entity

class CategoryRewardEntity extends Entity<String> {
  final String? name;
  final List<VoucherRewardEntity>? vouchers;

  const CategoryRewardEntity({required String id, this.name, this.vouchers})
    : super(id);

  @override
  List<Object?> get props => [id, name, vouchers];
}
