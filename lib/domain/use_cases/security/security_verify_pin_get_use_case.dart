import '../../../data/data.dart';
import '../../../locator.dart';
import '../../domain.dart';

// Verify Security pin useCase
abstract class SecurityVerifyPinGetUseCase
    implements
        BaseUseCase<SecurityVerifyPinGetResult, SecurityVerifyPinGetParams> {}

class SecurityVerifyPinGetUseCaseImpl extends SecurityVerifyPinGetUseCase {
  @override
  Future<SecurityVerifyPinGetResult> execute(
    SecurityVerifyPinGetParams params,
  ) async {
    try {
      // Verify security pin
      SecurityRepository securityRepository = sl();
      var verifySecurityPin = await securityRepository.verifySecurityPin(
        token: params.token,
        pin: params.pin,
      );

      // If got data, pass to SecurityVerifyPinGetResult
      // if (verifySecurityPin['status']) {
      return SecurityVerifyPinGetResult(data: verifySecurityPin, result: true);
      // }
    } catch (e) {
      rethrow;
    }

    // // If no data, pass to SecurityVerifyPinGetException
    // return SecurityVerifyPinGetResult(
    //   data: false,
    //   result: false,
    //   exception: SecurityVerifyPinGetException(
    //     exception: Exception('No security otp code Found'),
    //   ),
    // );
  }
}

// SecurityVerifyPinGetResult is trigger when result != null
class SecurityVerifyPinGetResult extends UseCaseResult {
  dynamic data;

  SecurityVerifyPinGetResult({
    required this.data,
    super.exception,
    super.result,
  });
}

// SecurityVerifyPinGetParams class is defined and wrapped around the parameters
class SecurityVerifyPinGetParams {
  String token;
  String pin;

  SecurityVerifyPinGetParams({required this.token, required this.pin});
}

// Trigger Exception
class SecurityVerifyPinGetException implements Exception {
  Exception exception;

  SecurityVerifyPinGetException({required this.exception});
}
