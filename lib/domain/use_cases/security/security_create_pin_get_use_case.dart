import '../../../data/data.dart';
import '../../../locator.dart';
import '../../domain.dart';

// Security pin create useCase

abstract class SecurityCreatePinGetUseCase
    implements
        BaseUseCase<SecurityCreatePinGetResult, SecurityCreatePinGetParams> {}

class SecurityCreatePinGetUseCaseImpl extends SecurityCreatePinGetUseCase {
  @override
  Future<SecurityCreatePinGetResult> execute(
    SecurityCreatePinGetParams params,
  ) async {
    try {
      // Create/ register security pin
      SecurityRepository securityRepository = sl();
      var createPin = await securityRepository.createSecurityPin(
        token: params.token,
        otpToken: params.otpToken,
        otp: params.otp,
        pin: params.pin,
      );

      // // If got data, pass to SecurityCreatePinGetResult
      // if (createPin['status'] == true) {
      return SecurityCreatePinGetResult(createPin: createPin, result: true);
      // }
    } catch (e) {
      rethrow;
    }

    // // If no data, pass to SecurityCreatePinGetException
    // return SecurityCreatePinGetResult(
    //   createPin: false,
    //   result: false,
    //   exception: SecurityCreatePinGetException(
    //     exception: Exception('Security Pin Not Created.'),
    //   ),
    // );
  }
}

// SecurityCreatePinGetResult is trigger when result != null
class SecurityCreatePinGetResult extends UseCaseResult {
  dynamic createPin;

  SecurityCreatePinGetResult({
    required this.createPin,
    super.exception,
    super.result,
  });
}

// SecurityCreatePinGetParams class is defined and wrapped around the parameters
class SecurityCreatePinGetParams {
  String token;
  String otpToken;
  String otp;
  String pin;

  SecurityCreatePinGetParams({
    required this.token,
    required this.otpToken,
    required this.otp,
    required this.pin,
  });
}

// Trigger Exception
class SecurityCreatePinGetException implements Exception {
  Exception exception;

  SecurityCreatePinGetException({required this.exception});
}
