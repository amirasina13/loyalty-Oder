import '../../../data/data.dart';
import '../../../locator.dart';
import '../../domain.dart';

// Credit history useCase

abstract class CreditHistoryTransactionsGetUseCase
    implements
        BaseUseCase<
          CreditHistoryTransactionsGetResult,
          CreditHistoryTransactionsGetParams
        > {}

class CreditHistoryTransactionsGetUseCaseImpl
    extends CreditHistoryTransactionsGetUseCase {
  @override
  Future<CreditHistoryTransactionsGetResult> execute(
    CreditHistoryTransactionsGetParams params,
  ) async {
    try {
      // Get credit list history
      HistoryRepository historyRepository = sl();
      var history = await historyRepository.listCreditHistory(
        params.token,
        params.page,
      );

      // If got data, pass to CreditHistoryTransactionsGetResult
      return CreditHistoryTransactionsGetResult(history: history, result: true);
    } catch (e) {
      rethrow;
    }
  }
}

// CreditHistoryTransactionsGetResult is trigger when result != null
class CreditHistoryTransactionsGetResult extends UseCaseResult {
  dynamic history;

  CreditHistoryTransactionsGetResult({
    required this.history,
    super.exception,
    super.result,
  });
}

// CreditHistoryTransactionsGetParams class is defined and wrapped around the parameters
class CreditHistoryTransactionsGetParams {
  String token;
  int page;

  CreditHistoryTransactionsGetParams({required this.token, required this.page});
}

// Trigger Exception
class CreditHistoryTransactionsGetException implements Exception {
  Exception exception;

  CreditHistoryTransactionsGetException({required this.exception});
}
