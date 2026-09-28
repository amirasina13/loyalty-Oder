import '../../../data/data.dart';
import '../../../locator.dart';
import '../../domain.dart';

// Bulletin/ IF News details useCase

abstract class BulletinDetailsGetUseCase
    implements
        BaseUseCase<BulletinDetailsGetResult, BulletinDetailsGetParams> {}

class BulletinDetailsGetUseCaseImpl extends BulletinDetailsGetUseCase {
  @override
  Future<BulletinDetailsGetResult> execute(
    BulletinDetailsGetParams params,
  ) async {
    try {
      // Get bulletin details
      BulletinRepository bulletinRepository = sl();
      var details = await bulletinRepository.getDetails(
        params.token,
        params.bulletinId,
      );

      // If got data, pass to BulletinDetailsGetResult
      if (details != null) {
        return BulletinDetailsGetResult(details: details, result: true);
      }
    } catch (e) {
      rethrow;
    }

    // If no data, pass to BulletinDetailsGetException
    return BulletinDetailsGetResult(
      details: null,
      result: false,
      exception: BulletinDetailsGetException(
        exception: Exception('No Details Found'),
      ),
    );
  }
}

// BulletinDetailsGetResult is trigger when result != null
class BulletinDetailsGetResult extends UseCaseResult {
  dynamic details;

  BulletinDetailsGetResult({
    required this.details,
    super.exception,
    super.result,
  });
}

// BulletinDetailsGetParams class is defined and wrapped around the parameters
class BulletinDetailsGetParams {
  String token;
  String bulletinId;

  BulletinDetailsGetParams({required this.token, required this.bulletinId});
}

// Trigger Exception
class BulletinDetailsGetException implements Exception {
  Exception exception;

  BulletinDetailsGetException({required this.exception});
}
