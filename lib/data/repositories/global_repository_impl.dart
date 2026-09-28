import '../data.dart';

// Repository for global

class GlobalRepositoryImpl extends GlobalRepository {
  final RemoteGlobalRepository remoteGlobalRepository;

  GlobalRepositoryImpl({required this.remoteGlobalRepository});

  @override
  Future<List<Country>> getCountries() async {
    return remoteGlobalRepository.getCountries();
  }

  @override
  Future<Map> getGlobalData() async {
    return remoteGlobalRepository.getGlobalData();
  }
}
