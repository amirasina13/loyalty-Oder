import '../data.dart';
// Repository for reward/If Perks

class RewardRepositoryImpl extends RewardRepository {
  final RemoteRewardRepository remoteRewardRepository;

  RewardRepositoryImpl({required this.remoteRewardRepository});

  @override
  Future<dynamic> filteringCategory(String token) async {
    return remoteRewardRepository.filteringCategory(token);
  }

  @override
  Future<dynamic> listRewards(
    String filterBy,
    String filterValue,
    int offset,
    String token,
  ) async {
    return remoteRewardRepository.listRewards(
      filterBy,
      filterValue,
      offset,
      token,
    );
  }

  @override
  Future<dynamic> listRewardsMerchant(String merchantId, String token) async {
    return remoteRewardRepository.listRewardsMerchant(merchantId, token);
  }

  @override
  Future<dynamic> getDetails(
    String token,
    String rewardId,
    String latitude,
    String longitude,
  ) async {
    return remoteRewardRepository.getDetails(
      token,
      rewardId,
      latitude,
      longitude,
    );
  }

  @override
  Future<dynamic> getDetailsDynamic(
    String token,
    String code,
    String latitude,
    String longitude,
  ) async {
    return remoteRewardRepository.getDetailsDynamic(
      token,
      code,
      latitude,
      longitude,
    );
  }

  @override
  Future<dynamic> downloadVoucher(
    String voucherId,
    String pin,
    String referral,
    String quantity,
    String token,
  ) async {
    return remoteRewardRepository.downloadVoucher(
      voucherId,
      pin,
      referral,
      quantity,
      token,
    );
  }

  @override
  Future<dynamic> purchaseVoucher(
    String voucherId,
    String redeemVia,
    String pin,
    String points,
    String referral,
    String quantity,
    String token,
  ) async {
    return remoteRewardRepository.purchaseVoucher(
      voucherId,
      redeemVia,
      pin,
      points,
      referral,
      quantity,
      token,
    );
  }

  @override
  Future<dynamic> redeemRewardQr(String code, String token) async {
    return remoteRewardRepository.redeemRewardQr(code, token);
  }

  @override
  Future<dynamic> searchVouchersBrands({
    required String token,
    String? keywords,
  }) async {
    return remoteRewardRepository.searchVouchersBrands(
      token: token,
      keywords: keywords,
    );
  }

  @override
  Future<dynamic> addRemoveFavourite({
    required String token,
    required String voucherId,
  }) async {
    return remoteRewardRepository.addRemoveFavourite(
      token: token,
      voucherId: voucherId,
    );
  }

  @override
  Future<dynamic> getFavourite({
    required String token,
    required String latitude,
    required String longitude,
  }) async {
    return remoteRewardRepository.getFavourite(
      token: token,
      latitude: latitude,
      longitude: longitude,
    );
  }
}
