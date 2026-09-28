import '../../../data/data.dart';
import '../../../locator.dart';
import '../../domain.dart';

// Point history transaction useCase

abstract class NearbyOutletGetUseCase
    implements BaseUseCase<NearbyOutletGetResult, NearbyOutletGetParams> {}

class NearbyOutletGetUseCaseImpl extends NearbyOutletGetUseCase {
  @override
  Future<NearbyOutletGetResult> execute(NearbyOutletGetParams params) async {
    try {
      // Get point history list
      OrderingRepository orderingRepository = sl();
      var outlets = await orderingRepository.listNearbyOutlet(
        params.token,
        params.latitude,
        params.longitude,
        params.page,
      );

      // If got data, pass to NearbyOutletGetResult
      return NearbyOutletGetResult(outlets: outlets, result: true);
    } catch (e) {
      rethrow;
    }
  }
}

// NearbyOutletGetResult is trigger when result != null
class NearbyOutletGetResult extends UseCaseResult {
  dynamic outlets;

  NearbyOutletGetResult({required this.outlets, super.exception, super.result});
}

// NearbyOutletGetParams class is defined and wrapped around the parameters
class NearbyOutletGetParams {
  String token;
  String latitude;
  String longitude;
  int page;

  NearbyOutletGetParams({
    required this.token,
    required this.latitude,
    required this.longitude,
    required this.page,
  });
}

// Trigger Exception
class NearbyOutletGetException implements Exception {
  Exception exception;

  NearbyOutletGetException({required this.exception});
}
