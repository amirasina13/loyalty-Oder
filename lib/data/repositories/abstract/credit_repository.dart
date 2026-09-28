// Abstract repository for credit

abstract class CreditRepository {
  Future<dynamic> getCreditPayment({
    required String token,
    required String pin,
  });

  Future<dynamic> onlineCreditPayment(String token, String amount, String pin);

  Future<dynamic> pointConversion({
    required String token,
    required String pin,
    required String pointsConvert,
  });
}
