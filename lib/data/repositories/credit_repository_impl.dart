import '../data.dart';

// Repository for credit

class CreditRepositoryImpl extends CreditRepository {
  final RemoteCreditRepository remoteCreditRepository;

  CreditRepositoryImpl({required this.remoteCreditRepository});

  @override
  Future<dynamic> getCreditPayment({
    required String token,
    required String pin,
  }) async {
    return remoteCreditRepository.getCreditPayment(token: token, pin: pin);
  }

  @override
  Future<dynamic> onlineCreditPayment(
    String token,
    String amount,
    String pin,
  ) async {
    return remoteCreditRepository.onlineCreditPayment(token, amount, pin);
  }

  @override
  Future<dynamic> pointConversion({
    required String token,
    required String pin,
    required String pointsConvert,
  }) async {
    return remoteCreditRepository.pointConversion(
      token: token,
      pin: pin,
      pointsConvert: pointsConvert,
    );
  }
}
