import '../../../data/data.dart';
import '../../../locator.dart';
import '../../domain.dart';

// Reward/ IF Perks purchase voucher useCase

abstract class RewardPurchaseGetUseCase
    implements BaseUseCase<RewardPurchaseGetResult, RewardPurchaseGetParams> {}

class RewardPurchaseGetUseCaseImpl extends RewardPurchaseGetUseCase {
  @override
  Future<RewardPurchaseGetResult> execute(
    RewardPurchaseGetParams params,
  ) async {
    try {
      // Purchase reward/ IF Perks voucher
      RewardRepository purchaseRepository = sl();
      var success = await purchaseRepository.purchaseVoucher(
        params.voucherId,
        params.redeemVia,
        params.pin,
        params.points,
        params.referral,
        params.quantity,
        params.token,
      );

      // If got data, pass to RewardPurchaseGetResult
      // if (success != null) {
      return RewardPurchaseGetResult(success: success, result: true);
      // }
    } catch (e) {
      rethrow;
    }

    // // If no data, pass to RewardPurchaseGetException
    // return RewardPurchaseGetResult(
    //     success: null,
    //     result: false,
    //     exception: RewardPurchaseGetException(
    //         exception: Exception('No Reward Found')));
  }
}

// RewardPurchaseGetResult is trigger when result != null
class RewardPurchaseGetResult extends UseCaseResult {
  dynamic success;

  RewardPurchaseGetResult({
    required this.success,
    super.exception,
    super.result,
  });
}

// RewardPurchaseGetParams class is defined and wrapped around the parameters
class RewardPurchaseGetParams {
  String voucherId;
  String redeemVia;
  String pin;
  String points;
  String referral;
  String quantity;
  String token;

  RewardPurchaseGetParams({
    required this.voucherId,
    required this.redeemVia,
    required this.pin,
    required this.points,
    required this.referral,
    required this.quantity,
    required this.token,
  });
}

// Trigger Exception
class RewardPurchaseGetException implements Exception {
  Exception exception;

  RewardPurchaseGetException({required this.exception});
}
