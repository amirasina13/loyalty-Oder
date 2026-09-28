import '../../../data/data.dart';
import '../../../locator.dart';
import '../../domain.dart';

// Point history transaction useCase

abstract class HistoryTransactionsGetUseCase
    implements
        BaseUseCase<
          HistoryTransactionsGetResult,
          HistoryTransactionsGetParams
        > {}

class HistoryTransactionsGetUseCaseImpl extends HistoryTransactionsGetUseCase {
  @override
  Future<HistoryTransactionsGetResult> execute(
    HistoryTransactionsGetParams params,
  ) async {
    try {
      // Get point history list
      HistoryRepository historyRepository = sl();
      var history = await historyRepository.listPointHistory(
        params.token,
        params.page,
      );

      // If got data, pass to HistoryTransactionsGetResult
      return HistoryTransactionsGetResult(history: history, result: true);
    } catch (e) {
      rethrow;
    }
  }
}

// HistoryTransactionsGetResult is trigger when result != null
class HistoryTransactionsGetResult extends UseCaseResult {
  dynamic history;

  HistoryTransactionsGetResult({
    required this.history,
    super.exception,
    super.result,
  });
}

// HistoryTransactionsGetParams class is defined and wrapped around the parameters
class HistoryTransactionsGetParams {
  String token;
  int page;

  HistoryTransactionsGetParams({required this.token, required this.page});
}

// Trigger Exception
class HistoryTransactionsGetException implements Exception {
  Exception exception;

  HistoryTransactionsGetException({required this.exception});
}
