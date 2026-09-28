import '../../../data/data.dart';
import '../../../locator.dart';
import '../../domain.dart';

// Outlet list useCase

abstract class OutletListGetUseCase
    implements BaseUseCase<OutletListGetResult, OutletListGetParams> {}

class OutletListGetUseCaseImpl extends OutletListGetUseCase {
  @override
  Future<OutletListGetResult> execute(OutletListGetParams params) async {
    try {
      // Get list outlet
      OrderingRepository orderingRepository = sl();
      var outlets = await orderingRepository.listOutlets(
        params.brandId,
        params.latitude,
        params.longitude,
        params.token,
      );

      // If got data, pass to OutletListGetResult
      if (outlets != null) {
        return OutletListGetResult(outlets: outlets, result: true);
      }
    } catch (e) {
      rethrow;
    }

    // If no data, pass to OutletListGetException
    return OutletListGetResult(
      outlets: null,
      result: false,
      exception: OutletListGetException(
        exception: Exception('No Outlets Found'),
      ),
    );
  }
}

// OutletListGetResult is trigger when result != null
class OutletListGetResult extends UseCaseResult {
  dynamic outlets;

  OutletListGetResult({required this.outlets, super.exception, super.result});
}

// OutletListGetParams class is defined and wrapped around the parameters
class OutletListGetParams {
  String brandId;
  String latitude;
  String longitude;
  String token;

  OutletListGetParams({
    required this.brandId,
    required this.latitude,
    required this.longitude,
    required this.token,
  });
}

// Trigger Exception
class OutletListGetException implements Exception {
  Exception exception;

  OutletListGetException({required this.exception});
}
