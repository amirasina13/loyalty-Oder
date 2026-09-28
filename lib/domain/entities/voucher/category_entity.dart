import '../../domain.dart';

// Categories entity

class CategoryEntity extends Entity<String> {
  final String? name;
  final int? total;
  final List<VoucherEntity>? vouchers;

  const CategoryEntity({
    required String id,
    this.name,
    this.total,
    this.vouchers,
  }) : super(id);

  @override
  List<Object?> get props => [id, name, total, vouchers];
}
