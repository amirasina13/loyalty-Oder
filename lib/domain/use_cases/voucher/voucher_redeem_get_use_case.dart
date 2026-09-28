import '../../../data/data.dart';
import '../../../locator.dart';
import '../../domain.dart';

// Reward/ IF Perks purchase voucher useCase

abstract class RedeemVoucherGetUseCase
    implements BaseUseCase<RedeemVoucherGetResult, RedeemVoucherGetParams> {}

class RedeemVoucherGetUseCaseImpl extends RedeemVoucherGetUseCase {
  @override
  Future<RedeemVoucherGetResult> execute(RedeemVoucherGetParams params) async {
    try {
      // Purchase reward/ IF Perks voucher
      VoucherRepository voucherRedeemRepository = sl();
      var redeemResponse = await voucherRedeemRepository.redeemVoucher(
        params.voucherId,
        params.qrCode,
        params.pin,
        params.token,
      );

      // If got data, pass to RedeemVoucherGetResult
      // if (success == true) {
      return RedeemVoucherGetResult(
        redeemResponse: redeemResponse,
        result: true,
      );
      // }
    } catch (e) {
      rethrow;
    }

    // // If no data, pass to RedeemVoucherGetException
    // return RedeemVoucherGetResult(
    //     redeemResponse: false,
    //     result: false,
    //     exception: RedeemVoucherGetException(
    //         exception: Exception('No Reward Found')));
  }
}

// RedeemVoucherGetResult is trigger when result != null
class RedeemVoucherGetResult extends UseCaseResult {
  dynamic redeemResponse;

  RedeemVoucherGetResult({
    required this.redeemResponse,
    super.exception,
    super.result,
  });
}

// RedeemVoucherGetParams class is defined and wrapped around the parameters
class RedeemVoucherGetParams {
  String voucherId;
  String qrCode;
  String pin;
  String token;

  RedeemVoucherGetParams({
    required this.voucherId,
    required this.qrCode,
    required this.pin,
    required this.token,
  });
}

// Trigger Exception
class RedeemVoucherGetException implements Exception {
  Exception exception;

  RedeemVoucherGetException({required this.exception});
}
