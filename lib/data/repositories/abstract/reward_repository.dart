// Abstract repository for reward/ IF Perks

abstract class RewardRepository {
  Future<dynamic> filteringCategory(String token);

  Future<dynamic> listRewards(
    String filterBy,
    String filterValue,
    int offset,
    String token,
  );

  Future<dynamic> listRewardsMerchant(String merchantId, String token);

  Future<dynamic> getDetails(
    String token,
    String rewardId,
    String latitude,
    String longitude,
  );

  Future<dynamic> getDetailsDynamic(
    String token,
    String code,
    String latitude,
    String longitude,
  );

  Future<dynamic> downloadVoucher(
    String voucherId,
    String pin,
    String referral,
    String quantity,
    String token,
  );

  Future<dynamic> purchaseVoucher(
    String voucherId,
    String redeemVia,
    String pin,
    String points,
    String referral,
    String quantity,
    String token,
  );

  Future<dynamic> redeemRewardQr(String code, String token);

  Future<dynamic> searchVouchersBrands({
    required String token,
    String? keywords,
  });

  Future<dynamic> addRemoveFavourite({
    required String token,
    required String voucherId,
  });

  Future<dynamic> getFavourite({
    required String token,
    required String latitude,
    required String longitude,
  });
}
