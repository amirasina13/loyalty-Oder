import '../data.dart';

// Repository for history

class HistoryRepositoryImpl extends HistoryRepository {
  final RemoteHistoryRepository remoteHistoryRepository;

  HistoryRepositoryImpl({required this.remoteHistoryRepository});

  @override
  Future<dynamic> listPointHistory(String token, int page) async {
    return remoteHistoryRepository.listPointHistory(token, page);
  }

  @override
  Future<dynamic> listCreditHistory(String token, int page) async {
    return remoteHistoryRepository.listCreditHistory(token, page);
  }
}
