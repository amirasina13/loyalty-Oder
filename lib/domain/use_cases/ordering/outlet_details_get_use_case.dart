import '../../../data/data.dart';
import '../../../locator.dart';
import '../../domain.dart';

// Outlet details useCase

abstract class OutletDetailsGetUseCase
    implements BaseUseCase<OutletDetailsGetResult, OutletDetailsGetParams> {}

class OutletDetailsGetUseCaseImpl extends OutletDetailsGetUseCase {
  @override
  Future<OutletDetailsGetResult> execute(OutletDetailsGetParams params) async {
    try {
      // Get outlet details
      OrderingRepository orderingRepository = sl();
      var details = await orderingRepository.getDetails(
        params.outletId,
        params.token,
      );

      // If got data, pass to OutletDetailsGetResult
      return OutletDetailsGetResult(details: details, result: true);
    } catch (e) {
      rethrow;
    }
  }
}

// OutletDetailsGetResult is trigger when result != null
class OutletDetailsGetResult extends UseCaseResult {
  dynamic details;

  OutletDetailsGetResult({
    required this.details,
    super.exception,
    super.result,
  });
}

// OutletDetailsGetParams class is defined and wrapped around the parameters
class OutletDetailsGetParams {
  String outletId;
  String token;

  OutletDetailsGetParams({required this.outletId, required this.token});
}

// Trigger Exception
class OutletDetailsGetException implements Exception {
  Exception exception;

  OutletDetailsGetException({required this.exception});
}
