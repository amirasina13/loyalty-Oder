import '../../../data/data.dart';
import '../../../locator.dart';
import '../../domain.dart';

//  Security start useCase
abstract class SecurityStartGetUseCase
    implements BaseUseCase<SecurityStartGetResult, SecurityStartGetParams> {}

class SecurityStartGetUseCaseImpl extends SecurityStartGetUseCase {
  @override
  Future<SecurityStartGetResult> execute(SecurityStartGetParams params) async {
    try {
      // send security pin
      SecurityRepository securityRepository = sl();
      var startSecurity = await securityRepository.startSecurityPin(
        token: params.token,
      );

      // If got data, pass to SecurityStartGetResult
      // if (startSecurity['status'] == true) {
      return SecurityStartGetResult(securityOtp: startSecurity, result: true);
      // }
    } catch (e) {
      rethrow;
    }

    // // If no data, pass to SecurityStartGetException
    // return SecurityStartGetResult(
    //   securityOtp: '',
    //   result: false,
    //   exception: SecurityStartGetException(
    //     exception: Exception('No security otp code Found'),
    //   ),
    // );
  }
}

// SecurityStartGetResult is trigger when result != null
class SecurityStartGetResult extends UseCaseResult {
  dynamic securityOtp;

  SecurityStartGetResult({
    required this.securityOtp,
    super.exception,
    super.result,
  });
}

// SecurityStartGetParams class is defined and wrapped around the parameters
class SecurityStartGetParams {
  String token;

  SecurityStartGetParams({required this.token});
}

// Trigger Exception
class SecurityStartGetException implements Exception {
  Exception exception;

  SecurityStartGetException({required this.exception});
}
