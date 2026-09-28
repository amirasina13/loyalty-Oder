// Abstract repository for voucher

abstract class VoucherRepository {
  // Future<dynamic> listVouchers(String filter, String token); //OLD v

  Future<dynamic> listVoucherCategories(
    String filterBy,
    String filterValue,
    String token,
  );

  Future<dynamic> listPastVouchers(String token);

  Future<dynamic> getDetails(
    String token,
    String voucherId,
    String latitude,
    String longitude,
  );

  Future<dynamic> getPastVoucherDetails(String token, String voucherId);

  Future<dynamic> redeemVoucher(
    String voucherId,
    String qrCode,
    String pin,
    String token,
  );

  Future<dynamic> ratingVoucher(
    String id,
    int rating,
    String comment,
    String token,
  );
}
