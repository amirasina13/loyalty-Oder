import '../data.dart';

// Repository for ordering

class OrderingRepositoryImpl extends OrderingRepository {
  final RemoteOrderingRepository remoteOrderingRepository;

  OrderingRepositoryImpl({required this.remoteOrderingRepository});

  // @override
  // Future<dynamic> listMerchants(
  //     String token, String latitude, String longitude) async {
  //   return remoteOrderingRepository.listMerchants(token, latitude, longitude);
  // }

  @override
  Future<dynamic> listNearbyOutlet(
    String token,
    String latitude,
    String longitude,
    int offset,
  ) async {
    return remoteOrderingRepository.listNearbyOutlet(
      token,
      latitude,
      longitude,
      offset,
    );
  }

  @override
  Future<dynamic> listBrands(
    String token,
    String latitude,
    String longitude,
    String categoryId,
  ) async {
    return remoteOrderingRepository.listBrands(
      token,
      latitude,
      longitude,
      categoryId,
    );
  }

  @override
  Future<dynamic> listOutlets(
    String brandId,
    String latitude,
    String longitude,
    String token,
  ) async {
    return remoteOrderingRepository.listOutlets(
      brandId,
      latitude,
      longitude,
      token,
    );
  }

  @override
  Future<dynamic> getDetails(String outletId, String token) async {
    return remoteOrderingRepository.getDetails(outletId, token);
  }

  @override
  Future<dynamic> addRemoveBookmark({
    required String token,
    required String merchantId,
  }) async {
    return remoteOrderingRepository.addRemoveBookmark(
      token: token,
      merchantId: merchantId,
    );
  }

  @override
  Future<dynamic> getBookmark({
    required String token,
    required String latitude,
    required String longitude,
  }) async {
    return remoteOrderingRepository.getBookmark(
      token: token,
      latitude: latitude,
      longitude: longitude,
    );
  }

  @override
  Future<dynamic> addRemoveFavOutlet({
    required String token,
    required String outletId,
  }) async {
    return remoteOrderingRepository.addRemoveFavOutlet(
      token: token,
      outletId: outletId,
    );
  }

  @override
  Future<dynamic> getFavOutlet({
    required String token,
    required String latitude,
    required String longitude,
  }) async {
    return remoteOrderingRepository.getFavOutlet(
      token: token,
      latitude: latitude,
      longitude: longitude,
    );
  }
}
