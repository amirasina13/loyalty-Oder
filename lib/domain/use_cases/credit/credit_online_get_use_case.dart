import '../../../data/data.dart';
import '../../../locator.dart';
import '../../domain.dart';

// Credit Online useCase

abstract class CreditOnlineGetUseCase
    implements BaseUseCase<CreditOnlineResult, CreditOnlineParams> {}

class CreditOnlineGetUseCaseImpl implements CreditOnlineGetUseCase {
  @override
  Future<CreditOnlineResult> execute(CreditOnlineParams params) async {
    try {
      // Get online credit url
      CreditRepository creditRepository = sl();
      String url = await creditRepository.onlineCreditPayment(
        params.token,
        params.amount,
        params.pin,
      );

      // If got data, pass to CreditOnlineResult
      if (url.isNotEmpty) {
        return CreditOnlineResult(url: url, result: true);
      }
    } catch (e) {
      rethrow;
    }

    // If no data, pass to CreditOnlineResult
    return CreditOnlineResult(
      url: null,
      result: false,
      exception: CreditOnlineException(error: 'No Payment Gateway found'),
    );
  }
}

// CreditOnlineResult is trigger when result != null
class CreditOnlineResult extends UseCaseResult {
  dynamic url;

  CreditOnlineResult({required this.url, super.exception, super.result});
}

// CreditOnlineParams class is defined and wrapped around the parameters
class CreditOnlineParams {
  String token;
  String amount;
  String pin;

  CreditOnlineParams({
    required this.token,
    required this.amount,
    required this.pin,
  });
}

// Trigger Exception
class CreditOnlineException implements Exception {
  String error;

  CreditOnlineException({required this.error});
}
