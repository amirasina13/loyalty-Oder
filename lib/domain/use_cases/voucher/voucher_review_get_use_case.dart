import '../../../data/data.dart';
import '../../../locator.dart';
import '../../domain.dart';

// Reward/ IF Perks purchase voucher useCase

abstract class RatingVoucherGetUseCase
    implements BaseUseCase<RatingVoucherGetResult, RatingVoucherGetParams> {}

class RatingVoucherGetUseCaseImpl extends RatingVoucherGetUseCase {
  @override
  Future<RatingVoucherGetResult> execute(RatingVoucherGetParams params) async {
    try {
      // Purchase reward/ IF Perks voucher
      VoucherRepository voucherRatingRepository = sl();
      var ratingResponse = await voucherRatingRepository.ratingVoucher(
        params.id,
        params.rating,
        params.comment,
        params.token,
      );

      // If got data, pass to RatingVoucherGetResult
      // if (success == true) {
      return RatingVoucherGetResult(
        ratingResponse: ratingResponse,
        result: true,
      );
      // }
    } catch (e) {
      rethrow;
    }

    // // If no data, pass to RatingVoucherGetException
    // return RatingVoucherGetResult(
    //     redeemResponse: false,
    //     result: false,
    //     exception: RatingVoucherGetException(
    //         exception: Exception('No Reward Found')));
  }
}

// RatingVoucherGetResult is trigger when result != null
class RatingVoucherGetResult extends UseCaseResult {
  dynamic ratingResponse;

  RatingVoucherGetResult({
    required this.ratingResponse,
    super.exception,
    super.result,
  });
}

// RatingVoucherGetParams class is defined and wrapped around the parameters
class RatingVoucherGetParams {
  String id;
  int rating;
  String comment;
  String token;

  RatingVoucherGetParams({
    required this.id,
    required this.rating,
    required this.comment,
    required this.token,
  });
}

// Trigger Exception
class RatingVoucherGetException implements Exception {
  Exception exception;

  RatingVoucherGetException({required this.exception});
}
