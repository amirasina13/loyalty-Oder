import '../../../data/data.dart';
import '../../../locator.dart';
import '../../domain.dart';

// Brands list useCase

abstract class BrandsListGetUseCase
    implements BaseUseCase<BrandsListGetResult, BrandsListGetParams> {}

class BrandsListGetUseCaseImpl extends BrandsListGetUseCase {
  @override
  Future<BrandsListGetResult> execute(BrandsListGetParams params) async {
    try {
      // Get merchant list
      OrderingRepository orderingRepository = sl();
      var merchants = await orderingRepository.listBrands(
        params.token,
        params.latitude,
        params.longitude,
        params.categoryId,
      );

      // If got data, pass to BrandsListGetResult
      if (merchants != null) {
        return BrandsListGetResult(merchants: merchants, result: true);
      }
    } catch (e) {
      rethrow;
    }

    // If no data, pass to BrandsListGetException
    return BrandsListGetResult(
      merchants: null,
      result: false,
      exception: BrandsListGetException(
        exception: Exception('No Merchants Found'),
      ),
    );
  }
}

// BrandsListGetResult is trigger when result != null
class BrandsListGetResult extends UseCaseResult {
  dynamic merchants;

  BrandsListGetResult({required this.merchants, super.exception, super.result});
}

// BrandsListGetParams class is defined and wrapped around the parameters
class BrandsListGetParams {
  String token;
  String latitude;
  String longitude;
  String categoryId;

  BrandsListGetParams({
    required this.token,
    required this.latitude,
    required this.longitude,
    required this.categoryId,
  });
}

// Trigger Exception
class BrandsListGetException implements Exception {
  Exception exception;

  BrandsListGetException({required this.exception});
}
