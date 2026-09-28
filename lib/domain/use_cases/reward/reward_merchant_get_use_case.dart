import '../../../data/data.dart';
import '../../../locator.dart';
import '../../domain.dart';

// Rewar by merchant list useCase

abstract class RewardMerchantGetUseCase
    implements BaseUseCase<RewardMerchantGetResult, RewardMerchantGetParams> {}

class RewardMerchantGetUseCaseImpl extends RewardMerchantGetUseCase {
  @override
  Future<RewardMerchantGetResult> execute(
    RewardMerchantGetParams params,
  ) async {
    try {
      //  Get list rewards
      RewardRepository rewardRepository = sl();
      var rewards = await rewardRepository.listRewardsMerchant(
        params.merchantId,
        params.token,
      );

      // If got data, pass to OutletListGetResult
      if (rewards == null) {
        return RewardMerchantGetResult(
          rewards: rewards,
          result: false,
          exception: RewardMerchantGetException(
            exception: Exception('No List Found'),
          ),
        );
      }

      // If got data, pass to RewardMerchantGetResult
      return RewardMerchantGetResult(rewards: rewards, result: true);
    } catch (e) {
      rethrow;
    }
  }
}

// RewardMerchantGetResult is trigger when result != null
class RewardMerchantGetResult extends UseCaseResult {
  List<RewardMerchant> rewards;

  RewardMerchantGetResult({
    required this.rewards,
    super.exception,
    super.result,
  });
}

// RewardMerchantGetParams class is defined and wrapped around the parameters
class RewardMerchantGetParams {
  String merchantId;
  String token;

  RewardMerchantGetParams({required this.merchantId, required this.token});
}

// Trigger Exception
class RewardMerchantGetException implements Exception {
  Exception exception;

  RewardMerchantGetException({required this.exception});
}
