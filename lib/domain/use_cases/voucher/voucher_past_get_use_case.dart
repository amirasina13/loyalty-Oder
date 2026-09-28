import '../../../data/data.dart';
import '../../../locator.dart';
import '../../domain.dart';

// Voucher past list useCase

abstract class VoucherPastTransactionsGetUseCase
    implements
        BaseUseCase<
          VoucherPastTransactionsGetResult,
          VoucherPastTransactionsGetParams
        > {}

class VoucherPastTransactionsGetUseCaseImpl
    extends VoucherPastTransactionsGetUseCase {
  @override
  Future<VoucherPastTransactionsGetResult> execute(
    VoucherPastTransactionsGetParams params,
  ) async {
    try {
      // Get voucher past list
      VoucherRepository voucherPastRepository = sl();
      var vouchersPast = await voucherPastRepository.listPastVouchers(
        params.token,
      );

      // If got data, pass to VoucherPastTransactionsGetResult
      if (vouchersPast != null) {
        return VoucherPastTransactionsGetResult(
          vouchers: vouchersPast,
          result: true,
        );
      }
    } catch (e) {
      rethrow;
    }

    // If no data, pass to VoucherPastTransactionsGetException
    return VoucherPastTransactionsGetResult(
      vouchers: null,
      result: false,
      exception: VoucherPastTransactionsGetException(
        exception: Exception('No Vouchers Found'),
      ),
    );
  }
}

// VoucherPastTransactionsGetResult is trigger when result != null
class VoucherPastTransactionsGetResult extends UseCaseResult {
  dynamic vouchers;

  VoucherPastTransactionsGetResult({
    required this.vouchers,
    super.exception,
    super.result,
  });
}

// VoucherPastTransactionsGetParams class is defined and wrapped around the parameters
class VoucherPastTransactionsGetParams {
  String token;

  VoucherPastTransactionsGetParams({required this.token});
}

// Trigger Exception
class VoucherPastTransactionsGetException implements Exception {
  Exception exception;

  VoucherPastTransactionsGetException({required this.exception});
}
