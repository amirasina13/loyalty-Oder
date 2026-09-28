import '../../../data/data.dart';
import '../../../locator.dart';
import '../../domain.dart';

// Verify security otp useCase

abstract class SecurityVerifyOtpGetUseCase
    implements
        BaseUseCase<SecurityVerifyOtpGetResult, SecurityVerifyOtpGetParams> {}

class SecurityVerifyOtpGetUseCaseImpl extends SecurityVerifyOtpGetUseCase {
  @override
  Future<SecurityVerifyOtpGetResult> execute(
    SecurityVerifyOtpGetParams params,
  ) async {
    try {
      // Verify security otp
      SecurityRepository securityRepository = sl();
      var verifySecurityOtp = await securityRepository.verifySecurityOtp(
        token: params.token,
        otp: params.otp,
        otpToken: params.otpToken,
      );

      // If got data, pass to SecurityVerifyOtpGetResult
      return SecurityVerifyOtpGetResult(
        securityOtp: verifySecurityOtp,
        result: true,
      );
    } catch (e) {
      rethrow;
    }
  }
}

// SecurityVerifyOtpGetResult is trigger when result != null
class SecurityVerifyOtpGetResult extends UseCaseResult {
  dynamic securityOtp;

  SecurityVerifyOtpGetResult({
    required this.securityOtp,
    super.exception,
    super.result,
  });
}

// SecurityVerifyOtpGetParams class is defined and wrapped around the parameters
class SecurityVerifyOtpGetParams {
  String token;
  String otp;
  String otpToken;

  SecurityVerifyOtpGetParams({
    required this.token,
    required this.otp,
    required this.otpToken,
  });
}

// Trigger Exception
class SecurityVerifyOtpGetException implements Exception {
  Exception exception;

  SecurityVerifyOtpGetException({required this.exception});
}
