// Abstract repository for transfer

abstract class TransferRepository {
  Future<dynamic> verifyTransfer({
    required String token,
    required String qrCode,
  });

  Future<dynamic> transferCredit({
    required String token,
    required String qrCode,
    required String amount,
    required String pin,
  });
}
