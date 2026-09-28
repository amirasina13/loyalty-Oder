import '../../../data/data.dart';
import '../../../locator.dart';
import '../../domain.dart';

// Reward/ IF Perks purchase voucher useCase

abstract class RewardRedeemQrGetUseCase
    implements BaseUseCase<RewardRedeemQrGetResult, RewardRedeemQrGetParams> {}

class RewardRedeemQrGetUseCaseImpl extends RewardRedeemQrGetUseCase {
  @override
  Future<RewardRedeemQrGetResult> execute(
    RewardRedeemQrGetParams params,
  ) async {
    try {
      // Purchase reward/ IF Perks voucher
      RewardRepository redeemQrRepository = sl();
      var redeemResponse = await redeemQrRepository.redeemRewardQr(
        params.code,
        params.token,
      );

      // If got data, pass to RewardRedeemQrGetResult
      // if (success == true) {

      return RewardRedeemQrGetResult(
        redeemResponse: redeemResponse,
        result: true,
      );
      // }
    } catch (e) {
      rethrow;
    }

    // // If no data, pass to RewardRedeemQrGetException
    // return RewardRedeemQrGetResult(
    //     redeemResponse: false,
    //     result: false,
    //     exception: RewardRedeemQrGetException(
    //         exception: Exception('No Reward Found')));
  }
}

// RewardRedeemQrGetResult is trigger when result != null
class RewardRedeemQrGetResult extends UseCaseResult {
  dynamic redeemResponse;

  RewardRedeemQrGetResult({
    required this.redeemResponse,
    super.exception,
    super.result,
  });
}

// RewardRedeemQrGetParams class is defined and wrapped around the parameters
class RewardRedeemQrGetParams {
  String code;
  String token;

  RewardRedeemQrGetParams({required this.code, required this.token});
}

// Trigger Exception
class RewardRedeemQrGetException implements Exception {
  Exception exception;

  RewardRedeemQrGetException({required this.exception});
}
