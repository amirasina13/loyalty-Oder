// Abstract repository for history

abstract class HistoryRepository {
  Future<dynamic> listPointHistory(String token, int page);
  Future<dynamic> listCreditHistory(String token, int page);
}
