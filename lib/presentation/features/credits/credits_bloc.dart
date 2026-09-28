import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../../app_setting/app_setting.dart';
import '../../../data/data.dart';
import '../../../domain/domain.dart';
import '../../../locator.dart';
import 'credits.dart';

/* Bloc is create events to trigger the interactions with the app and then the bloc 
   in charge is going to emit the requested data with a state */

class CreditBloc extends Bloc<CreditEvent, CreditState> {
  final CreditPaymentGetUseCase _creditPaymentGetUseCase;
  final CreditOnlineGetUseCase _creditOnlineGetUseCase;
  final CreditRepository creditRepository;

  CreditBloc({required this.creditRepository})
    : _creditPaymentGetUseCase = sl(),
      _creditOnlineGetUseCase = sl(),
      super(CreditInitial()) {
    on<CreditPaymentLoad>((event, emit) async {
      await _mapCreditPaymentLoadEventToState(emit);
    });
    on<CreditOnlineLoad>((event, emit) async {
      await _mapCreditOnlineLoadEventToState(event, emit);
    });
    on<PointConvertLoad>((event, emit) async {
      await _mapPointConvertLoadEventToState(event, emit);
    });
  }

  Future<bool> checkInternet() async {
    var connectionResult = await Connectivity().checkConnectivity();

    return connectionResult.contains(ConnectivityResult.none);
  }

  // Function for payment qrcode
  Future<void> _mapCreditPaymentLoadEventToState(
    Emitter<CreditState> emit,
  ) async {
    emit(CreditLoading());

    // Check the internet
    var internet = await checkInternet();

    // If got internet,
    if (!internet) {
      try {
        // Call API
        var creditPaymentGetResults = await _creditPaymentGetUseCase.execute(
          CreditPaymentGetParams(
            token: Storage().token,
            pin: Storage().securityPin,
          ),
        );

        var details = creditPaymentGetResults.details;

        // If result empty,
        if (details == null) {
          // Show state empty
          emit(CreditPaymentEmpty());
          // else
        } else {
          if (details is CreditPayment) {
            // Show state Loaded
            emit(CreditPaymentLoaded(details: details));
          } else {
            if (details['isMaintenance'] == true) {
              emit(CreditMaintenanceError(message: details['message']));
            } else {
              CreditError(error: details['message']);
            }
          }
        }
        // If got error, show state error
      } catch (e) {
        if (e is InvalidSessionException) {
          emit(CreditSessionError(error: e.message));
        } else if (e is InvalidStatusException) {
          emit(CreditError(error: e.message));
        } else {
          emit(CreditError(error: e.toString()));
        }
      }
      //  Else if no network, show network state error
    } else {
      emit(CreditNetworkError(error: 'No internet Connection.'));
    }
  }

  // Function for online payment(get payment url)
  Future<void> _mapCreditOnlineLoadEventToState(
    event,
    Emitter<CreditState> emit,
  ) async {
    emit(CreditLoading());

    // Check network
    var internet = await checkInternet();

    // If got network
    if (!internet) {
      try {
        var amount = double.parse(event.amount).toStringAsFixed(2);

        // Call API
        var creditPaymentGetResults = await _creditOnlineGetUseCase.execute(
          CreditOnlineParams(
            token: Storage().token,
            amount: amount,
            pin: Storage().securityPin,
          ),
        );

        var creditOnline = creditPaymentGetResults.url;

        // If result empty,
        if (creditOnline == null) {
          // Show state empty
          emit(
            CreditError(
              error:
                  (creditPaymentGetResults.exception as CreditOnlineException)
                      .error,
            ),
          );
        } else {
          if (creditOnline is String) {
            // Show state Loaded
            emit(CreditOnlineLoaded(url: creditPaymentGetResults.url));
          } else {
            if (creditOnline['isMaintenance'] == true) {
              emit(CreditMaintenanceError(message: creditOnline['message']));
            } else {
              CreditError(error: creditOnline['message']);
            }
          }
        }

        // If got error, show state error
      } catch (e) {
        if (e is InvalidSessionException) {
          emit(CreditSessionError(error: e.message));
        } else if (e is InvalidStatusException) {
          emit(CreditError(error: e.message));
        } else {
          emit(CreditError(error: e.toString()));
        }
      }
      // If no network, show network state error
    } else {
      emit(CreditNetworkError(error: 'No internet Connection.'));
    }
  }

  // Function for online payment(get payment url)
  Future<void> _mapPointConvertLoadEventToState(
    event,
    Emitter<CreditState> emit,
  ) async {
    emit(CreditLoading());

    // Check network
    var internet = await checkInternet();

    // If got network
    if (!internet) {
      try {
        // Call API
        var pointConverted = await creditRepository.pointConversion(
          token: Storage().token,
          pin: event.pin,
          pointsConvert: event.pointConvert,
        );

        if (pointConverted['isMaintenance'] == true) {
          // Show state Loaded
          emit(CreditMaintenanceError(message: pointConverted['message']));
        } else {
          // If result status false,
          if (pointConverted['status'] == false) {
            // Show state empty
            emit(CreditError(error: pointConverted['message']));
          } else {
            // Show state Loaded
            emit(ConvertSuccess(pointConverted['message']));
          }
        }

        // If got error, show state error
      } catch (e) {
        if (e is InvalidSessionException) {
          emit(CreditSessionError(error: e.message));
        } else if (e is InvalidStatusException) {
          emit(CreditError(error: e.message));
        } else {
          emit(CreditError(error: e.toString()));
        }
      }

      // If no network, show network state error
    } else {
      emit(CreditNetworkError(error: 'No internet Connection.'));
    }
  }
}
