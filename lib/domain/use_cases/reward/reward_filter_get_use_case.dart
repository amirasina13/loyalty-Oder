import '../../../data/data.dart';
import '../../../locator.dart';
import '../../domain.dart';

// Reward/ If Perks details useCase

abstract class FilterCategoryGetUseCase
    implements BaseUseCase<FilterCategoryGetResult, FilterCategoryGetParams> {}

class FilterCategoryGetUseCaseImpl extends FilterCategoryGetUseCase {
  @override
  Future<FilterCategoryGetResult> execute(
    FilterCategoryGetParams params,
  ) async {
    try {
      // Get reward details
      RewardRepository rewardRepository = sl();
      var filterData = await rewardRepository.filteringCategory(params.token);

      if (filterData == null) {
        return FilterCategoryGetResult(filterData: null, result: false);
      }

      // If got data, pass to FilterCategoryGetResult
      return FilterCategoryGetResult(filterData: filterData, result: true);
    } catch (e) {
      rethrow;
    }
  }
}

// FilterCategoryGetResult is trigger when result != null
class FilterCategoryGetResult extends UseCaseResult {
  FilterData? filterData;

  FilterCategoryGetResult({
    required this.filterData,
    super.exception,
    super.result,
  });
}

// FilterCategoryGetParams class is defined and wrapped around the parameters
class FilterCategoryGetParams {
  String token;

  FilterCategoryGetParams({required this.token});
}

// Trigger Exception
class FilterCategoryGetException implements Exception {
  Exception exception;

  FilterCategoryGetException({required this.exception});
}
