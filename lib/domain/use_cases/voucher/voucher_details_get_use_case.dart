import '../../../data/data.dart';
import '../../../locator.dart';
import '../../domain.dart';

// Voucher deails useCase

abstract class VoucherDetailsGetUseCase
    implements BaseUseCase<VoucherDetailsGetResult, VoucherDetailsGetParams> {}

class VoucherDetailsGetUseCaseImpl extends VoucherDetailsGetUseCase {
  @override
  Future<VoucherDetailsGetResult> execute(
    VoucherDetailsGetParams params,
  ) async {
    try {
      // Get voucher details
      VoucherRepository voucherRepository = sl();
      var details = await voucherRepository.getDetails(
        params.token,
        params.voucherId,
        params.latitude,
        params.longitude,
      );

      // If got data, pass to VoucherDetailsGetResult
      // if (details.id != null) {
      return VoucherDetailsGetResult(details: details, result: true);
      // }
    } catch (e) {
      rethrow;
    }

    // // If no data, pass to VoucherDetailsGetException
    // return VoucherDetailsGetResult(
    //     details: null,
    //     result: false,
    //     exception: VoucherDetailsGetException(
    //         exception: Exception('No Vouchers Found')));
  }
}

// VoucherDetailsGetResult is trigger when result != null
class VoucherDetailsGetResult extends UseCaseResult {
  dynamic details;

  VoucherDetailsGetResult({
    required this.details,
    super.exception,
    super.result,
  });
}

// VoucherDetailsGetParams class is defined and wrapped around the parameters
class VoucherDetailsGetParams {
  String token;
  String voucherId;
  String latitude;
  String longitude;

  VoucherDetailsGetParams({
    required this.token,
    required this.voucherId,
    required this.latitude,
    required this.longitude,
  });
}

// Trigger Exception
class VoucherDetailsGetException implements Exception {
  Exception exception;

  VoucherDetailsGetException({required this.exception});
}
