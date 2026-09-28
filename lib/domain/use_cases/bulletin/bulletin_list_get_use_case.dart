import '../../../data/data.dart';
import '../../../locator.dart';
import '../../domain.dart';

// Bulletin/ IF News list useCase

abstract class BulletinListGetUseCase
    implements BaseUseCase<BulletinListGetResult, BulletinListGetParams> {}

class BulletinListGetUseCaseImpl extends BulletinListGetUseCase {
  @override
  Future<BulletinListGetResult> execute(BulletinListGetParams params) async {
    try {
      // Get bulletin list
      BulletinRepository bulletinRepository = sl();
      var bulletins = await bulletinRepository.listBulletin(
        params.token,
        params.type,
      );

      // If got data, pass to BulletinListGetResult
      if (bulletins.isNotEmpty) {
        return BulletinListGetResult(bulletins: bulletins, result: true);
      }
    } catch (e) {
      rethrow;
    }

    // If no data, pass to BulletinListGetException
    return BulletinListGetResult(
      bulletins: null,
      result: false,
      exception: BulletinListGetException(
        exception: Exception('No List Found'),
      ),
    );
  }
}

// BulletinListGetResult is trigger when result != null
class BulletinListGetResult extends UseCaseResult {
  dynamic bulletins;

  BulletinListGetResult({
    required this.bulletins,
    super.exception,
    super.result,
  });
}

// BulletinListGetParams class is defined and wrapped around the parameters
class BulletinListGetParams {
  String token;
  String type;

  BulletinListGetParams({required this.token, required this.type});
}

// Trigger Exception
class BulletinListGetException implements Exception {
  Exception exception;

  BulletinListGetException({required this.exception});
}
