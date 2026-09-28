import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../../data/data.dart';
import '../../../domain/domain.dart';
import '../../../locator.dart';
import 'country.dart';

class CountryBloc extends Bloc<CountryEvent, CountryState> {
  final GlobalCountriesGetUseCase globalCountriesGet;

  CountryBloc() : globalCountriesGet = sl(), super(CountryInitial()) {
    on<CountryLoad>((event, emit) async {
      await mapEventToState(event, emit);
    });
  }

  Future<bool> checkInternet() async {
    var connectionResult = await Connectivity().checkConnectivity();

    return connectionResult.contains(ConnectivityResult.none);
  }

  // Function to get the country code listing from API
  Future<void> mapEventToState(event, Emitter<CountryState> emit) async {
    // check internet connection first
    var internet = await checkInternet();

    if (!internet) {
      try {
        // Call country API to get list country code
        var globalCountriesGetResult = await globalCountriesGet.execute(
          GlobalCountriesGetParams(),
        );
        var countries = globalCountriesGetResult.countries;
        if (countries.isNotEmpty) {
          emit(CountryListLoaded(countries: countries));
        } else {
          emit(
            CountryError(
              error:
                  (globalCountriesGetResult.exception
                          as GlobalCountriesGetException)
                      .error,
            ),
          );
        }
        // If got error, popup error dialog
      } catch (e) {
        if (e is InvalidStatusException) {
          emit(CountryError(error: e.message));
        } else {
          emit(CountryError(error: e.toString()));
        }
      }
    } else {
      emit(CountryNetworkError(error: 'No Internet Connection.'));
    }
  }
}
