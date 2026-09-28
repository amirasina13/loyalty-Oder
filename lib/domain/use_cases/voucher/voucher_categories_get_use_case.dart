import '../../../data/data.dart';
import '../../../locator.dart';
import '../../domain.dart';

// Voucher by categories useCase

abstract class VoucherCategoriesGetUseCase
    implements
        BaseUseCase<VoucherCategoriesGetResult, VoucherCategoriesGetParams> {}

class VoucherCategoriesGetUseCaseImpl extends VoucherCategoriesGetUseCase {
  @override
  Future<VoucherCategoriesGetResult> execute(
    VoucherCategoriesGetParams params,
  ) async {
    try {
      // Get voucher list
      VoucherRepository voucherRepository = sl();
      var vouchers = await voucherRepository.listVoucherCategories(
        params.filterBy,
        params.filterValue,
        params.token,
      );

      if (vouchers == null) {
        return VoucherCategoriesGetResult(vouchers: null, result: false);
      }

      // If got data, pass to VoucherCategoriesGetResult

      return VoucherCategoriesGetResult(vouchers: vouchers, result: true);
    } catch (e) {
      rethrow;
    }
  }
}

// VoucherCategoriesGetResult is trigger when result != null
class VoucherCategoriesGetResult extends UseCaseResult {
  dynamic vouchers;

  VoucherCategoriesGetResult({
    required this.vouchers,
    super.exception,
    super.result,
  });
}

// VoucherCategoriesGetParams class is defined and wrapped around the parameters
class VoucherCategoriesGetParams {
  String filterBy;
  String filterValue;
  String token;

  VoucherCategoriesGetParams({
    required this.filterBy,
    required this.filterValue,
    required this.token,
  });
}

// Trigger Exception
class VoucherCategoriesGetException implements Exception {
  Exception exception;

  VoucherCategoriesGetException({required this.exception});
}
