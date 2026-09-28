import '../../domain.dart';

// Permissions entity

class PermissionsEntity extends Entity<int> {
  final bool? isMember;
  final bool? isVoucher;
  final bool? isPayment;
  final bool? isSubscription;

  const PermissionsEntity({
    required int id,
    this.isMember,
    this.isVoucher,
    this.isPayment,
    this.isSubscription,
  }) : super(id);

  @override
  List<Object?> get props => [
    id,
    isMember,
    isVoucher,
    isPayment,
    isSubscription,
  ];
}
