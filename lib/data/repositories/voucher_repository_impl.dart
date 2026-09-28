import '../data.dart';

// Repository for voucher

class VoucherRepositoryImpl extends VoucherRepository {
  final RemoteVoucherRepository remoteVoucherRepository;

  VoucherRepositoryImpl({required this.remoteVoucherRepository});

  // @override /*                                                                   OLD VERSION */
  // Future<dynamic> listVouchers(String filter, String token) async {
  //   return remoteVoucherRepository.listVouchers(filter, token);
  // }

  @override
  Future<dynamic> listVoucherCategories(
    String filterBy,
    String filterValue,
    String token,
  ) async {
    return remoteVoucherRepository.listVoucherCategories(
      filterBy,
      filterValue,
      token,
    );
  }

  @override
  Future<dynamic> listPastVouchers(String token) async {
    return remoteVoucherRepository.listPastVouchers(token);
  }

  @override
  Future<dynamic> getDetails(
    String token,
    String voucherId,
    String latitude,
    String longitude,
  ) async {
    return remoteVoucherRepository.getDetails(
      token,
      voucherId,
      latitude,
      longitude,
    );
  }

  @override
  Future<dynamic> getPastVoucherDetails(String token, String voucherId) async {
    return remoteVoucherRepository.getPastVoucherDetails(token, voucherId);
  }

  @override
  Future<dynamic> redeemVoucher(
    String voucherId,
    String qrCode,
    String pin,
    String token,
  ) async {
    return remoteVoucherRepository.redeemVoucher(voucherId, qrCode, pin, token);
  }

  @override
  Future<dynamic> ratingVoucher(
    String id,
    int rating,
    String comment,
    String token,
  ) async {
    return remoteVoucherRepository.ratingVoucher(id, rating, comment, token);
  }
}
