import '../../../data/data.dart';
import '../../../locator.dart';
import '../../domain.dart';

// Countries useCase

abstract class GlobalCountriesGetUseCase
    implements
        BaseUseCase<GlobalCountriesGetResult, GlobalCountriesGetParams> {}

class GlobalCountriesGetUseCaseImpl implements GlobalCountriesGetUseCase {
  @override
  Future<GlobalCountriesGetResult> execute(
    GlobalCountriesGetParams params,
  ) async {
    try {
      // Get country list
      GlobalRepository globalRepository = sl();
      var countries = await globalRepository.getCountries();

      // If got data, pass to GlobalCountriesGetResult
      if (countries.isNotEmpty) {
        return GlobalCountriesGetResult(countries: countries, result: true);
      }
    } catch (e) {
      // If no data, pass to GlobalCountriesGetException
      return GlobalCountriesGetResult(
        countries: [],
        result: false,
        exception: GlobalCountriesGetException(error: e.toString()),
      );
    }

    // If no data, pass to GlobalCountriesGetException
    return GlobalCountriesGetResult(
      countries: [],
      result: false,
      exception: GlobalCountriesGetException(error: 'No country loaded'),
    );
  }
}

// GlobalCountriesGetResult is trigger when result != null
class GlobalCountriesGetResult extends UseCaseResult {
  List<Country> countries;

  GlobalCountriesGetResult({
    required this.countries,
    super.exception,
    super.result,
  });
}

// GlobalCountriesGetParams class is defined and wrapped around the parameters
class GlobalCountriesGetParams {}

// Trigger Exception
class GlobalCountriesGetException implements Exception {
  String error;

  GlobalCountriesGetException({required this.error});
}
