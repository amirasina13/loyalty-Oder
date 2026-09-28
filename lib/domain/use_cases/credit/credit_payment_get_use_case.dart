import '../../../data/data.dart';
import '../../../locator.dart';
import '../../domain.dart';

// Credit Payment(qrcode for payment) useCase

abstract class CreditPaymentGetUseCase
    implements BaseUseCase<CreditPaymentGetResult, CreditPaymentGetParams> {}

class CreditPaymentGetUseCaseImpl extends CreditPaymentGetUseCase {
  @override
  Future<CreditPaymentGetResult> execute(CreditPaymentGetParams params) async {
    try {
      // Get credit payment qrcode
      CreditRepository creditRepository = sl();
      var details = await creditRepository.getCreditPayment(
        token: params.token,
        pin: params.pin,
      );

      // If got data, pass to CreditPaymentGetResult
      if (details != null) {
        return CreditPaymentGetResult(details: details, result: true);
      }
    } catch (e) {
      rethrow;
    }

    // If no data, pass to CreditPaymentGetException
    return CreditPaymentGetResult(
      details: null,
      result: false,
      exception: CreditPaymentGetException(
        exception: Exception('No Credits Payment Found'),
      ),
    );
  }
}

// CreditPaymentGetResult is trigger when result != null
class CreditPaymentGetResult extends UseCaseResult {
  dynamic details;

  CreditPaymentGetResult({
    required this.details,
    super.exception,
    super.result,
  });
}

// CreditPaymentGetParams class is defined and wrapped around the parameters
class CreditPaymentGetParams {
  String token;
  String pin;

  CreditPaymentGetParams({required this.token, required this.pin});
}

// Trigger Exception
class CreditPaymentGetException implements Exception {
  Exception exception;

  CreditPaymentGetException({required this.exception});
}
