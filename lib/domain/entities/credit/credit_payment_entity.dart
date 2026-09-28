import '../../domain.dart';

// Payment entity

class CreditPaymentEntity extends Entity<String> {
  final String? qr;
  final String? credits;

  const CreditPaymentEntity({required String id, this.qr, this.credits})
    : super(id);

  @override
  List<Object?> get props => [id, qr, credits];
}
