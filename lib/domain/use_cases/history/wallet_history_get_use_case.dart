import '../../../data/data.dart';
import '../../../locator.dart';
import '../../domain.dart';

// Credit history useCase

abstract class WalletCreditHistoryTransactionsGetUseCase
    implements
        BaseUseCase<
          WalletCreditHistoryTransactionsGetResult,
          WalletCreditHistoryTransactionsGetParams
        > {}

class WalletCreditHistoryTransactionsGetUseCaseImpl
    extends WalletCreditHistoryTransactionsGetUseCase {
  @override
  Future<WalletCreditHistoryTransactionsGetResult> execute(
    WalletCreditHistoryTransactionsGetParams params,
  ) async {
    try {
      // Get credit list history
      HistoryRepository historyRepository = sl();
      var history = await historyRepository.listCreditHistory(
        params.token,
        params.page,
      );

      // If got data, pass to WalletCreditHistoryTransactionsGetResult
      return WalletCreditHistoryTransactionsGetResult(
        history: history,
        result: true,
      );
    } catch (e) {
      rethrow;
    }
  }
}

// WalletCreditHistoryTransactionsGetResult is trigger when result != null
class WalletCreditHistoryTransactionsGetResult extends UseCaseResult {
  dynamic history;

  WalletCreditHistoryTransactionsGetResult({
    required this.history,
    super.exception,
    super.result,
  });
}

// WalletCreditHistoryTransactionsGetParams class is defined and wrapped around the parameters
class WalletCreditHistoryTransactionsGetParams {
  String token;
  int page;

  WalletCreditHistoryTransactionsGetParams({
    required this.token,
    required this.page,
  });
}

// Trigger Exception
class WalletCreditHistoryTransactionsGetException implements Exception {
  Exception exception;

  WalletCreditHistoryTransactionsGetException({required this.exception});
}
