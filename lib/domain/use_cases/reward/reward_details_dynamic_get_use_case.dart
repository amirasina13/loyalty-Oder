import '../../../data/data.dart';
import '../../../locator.dart';
import '../../domain.dart';

// Reward/ If Perks details with dynamic code useCase

abstract class RewardDetailsDynamicGetUseCase
    implements
        BaseUseCase<
          RewardDetailsDynamicGetResult,
          RewardDetailsDynamicGetParams
        > {}

class RewardDetailsDynamicGetUseCaseImpl
    extends RewardDetailsDynamicGetUseCase {
  @override
  Future<RewardDetailsDynamicGetResult> execute(
    RewardDetailsDynamicGetParams params,
  ) async {
    try {
      // Get reward details
      RewardRepository rewardRepository = sl();
      var details = await rewardRepository.getDetailsDynamic(
        params.token,
        params.code,
        params.latitude,
        params.longitude,
      );

      // If got data, pass to RewardDetailsDynamicGetResult
      return RewardDetailsDynamicGetResult(details: details, result: true);
    } catch (e) {
      rethrow;
    }
  }
}

// RewardDetailsDynamicGetResult is trigger when result != null
class RewardDetailsDynamicGetResult extends UseCaseResult {
  dynamic details;

  RewardDetailsDynamicGetResult({
    required this.details,
    super.exception,
    super.result,
  });
}

// RewardDetailsDynamicGetParams class is defined and wrapped around the parameters
class RewardDetailsDynamicGetParams {
  String token;
  String code;
  String latitude;
  String longitude;

  RewardDetailsDynamicGetParams({
    required this.token,
    required this.code,
    required this.latitude,
    required this.longitude,
  });
}

// Trigger Exception
class RewardDetailsDynamicGetException implements Exception {
  Exception exception;

  RewardDetailsDynamicGetException({required this.exception});
}
