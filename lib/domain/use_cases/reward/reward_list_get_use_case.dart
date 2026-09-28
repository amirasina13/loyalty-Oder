import '../../../data/data.dart';
import '../../../locator.dart';
import '../../domain.dart';

// Reward/ IF Perks list useCase

abstract class RewardListGetUseCase
    implements BaseUseCase<RewardListGetResult, RewardListGetParams> {}

class RewardListGetUseCaseImpl extends RewardListGetUseCase {
  @override
  Future<RewardListGetResult> execute(RewardListGetParams params) async {
    try {
      //  Get list rewards
      RewardRepository rewardRepository = sl();

      var rewards = await rewardRepository.listRewards(
        params.filterBy,
        params.filterValue,
        params.offset,
        params.token,
      );

      // If got data, pass to RewardListGetResult
      return RewardListGetResult(rewards: rewards, result: true);
    } catch (e) {
      rethrow;
    }
  }
}

// RewardListGetResult is trigger when result != null
class RewardListGetResult extends UseCaseResult {
  dynamic rewards;

  RewardListGetResult({required this.rewards, super.exception, super.result});
}

// RewardListGetParams class is defined and wrapped around the parameters
class RewardListGetParams {
  String filterBy;
  String filterValue;
  int offset;
  String token;

  RewardListGetParams({
    required this.filterBy,
    required this.filterValue,
    required this.offset,
    required this.token,
  });
}

// Trigger Exception
class RewardListGetException implements Exception {
  Exception exception;

  RewardListGetException({required this.exception});
}
