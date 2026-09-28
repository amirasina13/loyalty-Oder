import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

import '../authentication/authentication.dart';
import '../country/country.dart';
import 'splash.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final AuthenticationBloc authenticationBloc;
  final CountryBloc countryBloc;
  // final dynamicLink = FirebaseDynamicLinks.instance;

  SplashBloc({
    required this.authenticationBloc,
    required this.countryBloc,
  }) : super(SplashInitial()) {
    on<SplashStart>((event, emit) async {
      await _mapSplashAppCheckingEventToState(emit);
    });
  }

  Future<bool> checkInternet() async {
    var connectionResult = await Connectivity().checkConnectivity();

    return connectionResult.contains(ConnectivityResult.none);
  }

  Future<void> _mapSplashAppCheckingEventToState(
      Emitter<SplashState> emit) async {
    emit(SplashLoading());
    try {
      await Future.delayed(Duration(seconds: 1));
      await _mapSplashAppStartedEventToState(emit);
    } catch (e) {
      // emit(MonkError(error: (e.toString())));
    }
  }

  Future<void> _mapSplashAppStartedEventToState(
      Emitter<SplashState> emit) async {
    emit(SplashLoading());

    try {
      // During the Loading state we can do additional checks like,
      // if the internet connection is available or not etc..

      await Future.delayed(Duration(
          seconds: 1)); // This is to simulate that above checking process

      var internet = await checkInternet();
      if (internet) {
        emit(SplashNetworkError(error: 'No Internet Connection.'));
        authenticationBloc.add(AuthenticationAppStarted());
      } else {
        authenticationBloc.add(AuthenticationAppStarted());
      }
    } catch (e) {
      // emit(MonkError(error: (e.toString())));
    }
  }
}
