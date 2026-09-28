import '../../../data/data.dart';
import '../../../locator.dart';
import '../../domain.dart';

// Check Security pin useCase (already register security pin or not)

abstract class SecurityGetUseCase
    implements BaseUseCase<SecurityGetResult, SecurityGetParams> {}

class SecurityGetUseCaseImpl extends SecurityGetUseCase {
  @override
  Future<SecurityGetResult> execute(SecurityGetParams params) async {
    try {
      // Check security pin
      SecurityRepository securityRepository = sl();
      var checkSeurity = await securityRepository.checkSecurityPin(
        token: params.token,
      );

      // If got data, pass to SecurityGetResult
      // if (checkSeurity) {
      return SecurityGetResult(security: checkSeurity, result: true);
      // }
    } catch (e) {
      rethrow;
    }

    // // If no data, pass to SecurityGetException
    // return SecurityGetResult(
    //     security: false,
    //     result: false,
    //     exception:
    //         SecurityGetException(exception: Exception('No security Found')));
  }
}

// SecurityGetResult is trigger when result != null
class SecurityGetResult extends UseCaseResult {
  dynamic security;

  SecurityGetResult({required this.security, super.exception, super.result});
}

// SecurityGetParams class is defined and wrapped around the parameters
class SecurityGetParams {
  String token;

  SecurityGetParams({required this.token});
}

// Trigger Exception
class SecurityGetException implements Exception {
  Exception exception;

  SecurityGetException({required this.exception});
}
