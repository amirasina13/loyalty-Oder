import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app_setting/storage.dart';
import '../../../data/data.dart';
import '../country/country.dart';
import '../home/home.dart';
import '../profile/profile.dart';
import '../wallet/wallet.dart';
import '../webview/webview_deeplink.dart';
import 'authentication.dart';

/* Bloc is create events to trigger the interactions with the app and then the bloc 
   in charge is going to emit the requested data with a state */

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final ProfileBloc profileBloc;
  final HomeBloc homeBloc;
  final WalletBloc walletBloc;
  final CountryBloc countryBloc;
  final UserRepository userRepository;
  final GlobalRepository globalRepository;

  AuthenticationBloc({
    required this.profileBloc,
    required this.homeBloc,
    required this.walletBloc,
    required this.countryBloc,
    required this.userRepository,
    required this.globalRepository,
  }) : super(AuthenticationUninitialized()) {
    on<AuthenticationAppStarted>((event, emit) async {
      var isOnBoarded = await _getOnBoarding();

      if (isOnBoarded == '1') {
        await _mapAuthenticationAppStartedEventToState(emit);
      } else {
        emit(AuthenticationOnBoardingStarted());
      }
    });
    on<AuthenticationChecking>((event, emit) async {
      await _mapAuthenticatedCheckingEventToState(emit);
    });
    on<AuthenticationOnBoardingComplete>((event, emit) async {
      await _saveOnBoarding();
    });
    on<AuthenticationLoggedIn>((event, emit) async {
      await _mapAuthenticatedLoggedInEventToState(
        event.token,
        event.loginData,
        emit,
      );
    });
    on<AuthenticationLoggedOut>((event, emit) async {
      await _mapAuthenticatedLoggedOutEventToState(emit);
    });
  }

  Future<bool> checkInternet() async {
    var connectionResult = await Connectivity().checkConnectivity();

    final hasConnection = !connectionResult.contains(ConnectivityResult.none);
    return hasConnection;
  }

  // Function to check is token verify or not
  Future<void> _mapAuthenticationAppStartedEventToState(
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      // First, get token in storage
      var token = await _getToken();
      // Check the network
      var hasInternet = await checkInternet();

      //  Must have active internet connection
      if (!hasInternet) {
        emit(NetworkError(error: 'No internet Connection.'));
        return;
      }

      // Fetch & validate global configuration safely inside try block
      final getGlobal = await globalRepository.getGlobalData();
      if (getGlobal['status'] == true && getGlobal['data'] != null) {
        Storage().globalValue = getGlobal['data'];
      } else {
        // Missing required global configuration on cold start
        emit(AuthenticationError(error: 'Failed to load app configuration.'));
        return;
      }

      // Must have a stored token
      if (token.isEmpty) {
        emit(AuthenticationUnauthenticated());
        return;
      }

      // Proceed with authentication token validation only after config is verified
      final verifiedToken = await userRepository.verifyToken(token: token);

      if (verifiedToken['isMaintenance']) {
        emit(AuthMaintenanceError(message: verifiedToken['message']));
        return;
      }

      // if token is verified, go to _mapAuthenticatedLoggedInEventToState
      // will show splashLogin -> homepage
      if (verifiedToken['status'] == true && verifiedToken['data'] != null) {
        final loginData = verifiedToken['data'];
        Storage().token = token;
        await _saveToken(token);

        emit(AuthenticationAuthenticated(loginData: loginData));
        // if not, will call country API and show login screen
      } else {
        // countryBloc.add(CountryLoad());
        Storage().clearSessionData();
        emit(AuthenticationUnauthenticated());
      }
    } catch (e) {
      if (Storage().globalValue == null) {
        emit(NetworkError(error: 'No internet Connection.'));
      } else {
        emit(AuthenticationUnauthenticated());
      }
    }

    // if (!internet) {
    //   if (getGlobal['status'] == true) {
    //     var globalData = getGlobal['data'];

    //     Storage().globalValue = globalData;

    //     try {
    //       if (token != '') {
    //         // verify token first by calling the verifyToken API
    //         var verifiedToken = await userRepository.verifyToken(token: token);

    //         if (!verifiedToken['isMaintenance']) {
    //           // if token is verified, go to _mapAuthenticatedLoggedInEventToState
    //           // will show splashLogin -> homepage
    //           if (verifiedToken['status'] == true) {
    //             Storage().token = token;
    //             await _saveToken(token);

    //             emit(
    //               AuthenticationAuthenticated(loginData: verifiedToken['data']),
    //             );
    //             // if not, will call country API and show login screen
    //           } else {
    //             // countryBloc.add(CountryLoad());
    //             emit(AuthenticationUnauthenticated());
    //           }
    //         } else {
    //           emit(AuthMaintenanceError(message: verifiedToken['message']));
    //         }

    //         // if not, will call country API and show login screen
    //       } else {
    //         emit(AuthenticationUnauthenticated());
    //       }

    //       // }
    //     } catch (e) {
    //       if (e is InvalidStatusException) {
    //         emit(AuthenticationError(error: e.message));
    //       } else {
    //         emit(AuthenticationError(error: e.toString()));
    //       }
    //     }
    //   }
    // } else {
    //   emit(NetworkError(error: 'No internet Connection.'));
    // }
  }

  // Function to check is token verify or not
  Future<void> _mapAuthenticatedCheckingEventToState(
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      // First, get token in storage
      var token = await _getToken();

      // Check the network
      var hasInternet = await checkInternet();

      //  Must have active internet connection
      if (!hasInternet) {
        emit(NetworkError(error: 'No internet Connection.'));
        return;
      }

      // if got token store in storage
      if (token != '') {
        // verify token first by calling the verifyToken API
        var verifiedToken = await userRepository.verifyToken(token: token);

        if (!verifiedToken['isMaintenance']) {
          // if token is verified, go to _mapAuthenticatedLoggedInEventToState
          // will show splashLogin -> homepage
          if (verifiedToken['status'] == true) {
            await _saveToken(token);
            Storage().token = token;

            emit(AuthenticationChecked(loginData: verifiedToken['data']));
            // if not, will call country API and show login screen
          } else {
            emit(AuthenticationUnauthenticated());
          }
        } else {
          emit(AuthMaintenanceError(message: verifiedToken['message']));
        }

        // if not, will call country API and show login screen
      } else {
        // countryBloc.add(CountryLoad());
        emit(AuthenticationUnauthenticated());
      }
    } catch (e) {
      if (e is InvalidStatusException) {
        emit(AuthenticationError(error: e.message));
      } else {
        emit(AuthenticationError(error: e.toString()));
      }
    }
  }

  // Function to login
  Future<void> _mapAuthenticatedLoggedInEventToState(
    String token,
    Map loginData,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      await _saveToken(token);
      // if got token, save token in storage
      Storage().token = token;

      emit(AuthenticationAuthenticated(loginData: loginData));
    } catch (e) {
      if (e is InvalidNetworkException) {
        emit(NetworkError(error: e.message));
      }
    }
  }

  // Function to logout
  Future<void> _mapAuthenticatedLoggedOutEventToState(
    Emitter<AuthenticationState> emit,
  ) async {
    await _deleteToken();

    // Wipe in-memory user credentials and sensitive session context
    Storage().clearSessionData();

    // Clear volatile TempData
    TempData.voucherId = '';
    TempData.voucherRefCode = '';
    TempData.affiliateCode = '';
    TempData.currentPage = '';
    TempData.deeplink = '';

    // profileBloc.add(ProfileStart());
    // then call countryLoad event, then show loginScreen
    // countryBloc.add(CountryLoad());

    emit(AuthenticationUnauthenticated());
  }

  /// delete from keystore/keychain
  Future<void> _deleteToken() async {
    // await Storage().secureStorage.delete(key: 'access_token');
    await Storage().secureStorage.delete(key: 'token');
    // TempData.deeplink = '';
    // Storage().secureStorage.delete(key: 'dynamicLink');
    // Storage().secureStorage.deleteAll();
    // Storage().dynamicLink = null;
  }

  /// write to keystore/keychain
  Future<void> _saveToken(String token) async {
    await Storage().secureStorage.write(key: 'token', value: token);
  }

  /// read to keystore/keychain
  Future<String> _getToken() async {
    return await Storage().secureStorage.read(key: 'token') ?? '';
  }

  Future<void> _saveOnBoarding() async {
    await Storage().secureStorage.write(key: 'on_boarding', value: '1').then((
      value,
    ) {
      add(AuthenticationAppStarted());
    });
  }

  Future<String> _getOnBoarding() async {
    return await Storage().secureStorage.read(key: 'on_boarding') ?? '0';
  }
}
