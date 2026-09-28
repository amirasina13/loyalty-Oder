import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../../app_setting/app_setting.dart';
import '../../../data/data.dart';
import '../../../domain/domain.dart';
import '../../../locator.dart';
import 'bulletin.dart';

/* Bloc is create events to trigger the interactions with the app and then the bloc 
   in charge is going to emit the requested data with a state */

class BulletinBloc extends Bloc<BulletinEvent, BulletinState> {
  final BulletinListGetUseCase _bulletinListGetUseCase;
  final BulletinDetailsGetUseCase _bulletinDetailsGetUseCase;

  BulletinBloc()
    : _bulletinListGetUseCase = sl(),
      _bulletinDetailsGetUseCase = sl(),
      super(BulletinInitial()) {
    on<BulletinListLoad>((event, emit) async {
      await _mapBulletinListLoadEventToState(event, emit);
    });
    on<BulletinDetailsLoad>((event, emit) async {
      await _mapBulletinDetailsLoadEventToState(event, emit);
    });
  }

  Future<bool> checkInternet() async {
    var connectionResult = await Connectivity().checkConnectivity();

    return connectionResult.contains(ConnectivityResult.none);
  }

  // If BulletinListLoad is called, will call this function
  Future<void> _mapBulletinListLoadEventToState(
    event,
    Emitter<BulletinState> emit,
  ) async {
    emit(BulletinLoading());

    // check internet connection first
    var internet = await checkInternet();

    // if got connection
    if (!internet) {
      try {
        // call get bulletin list Api in bulletinListGetUseCase
        var bulletinListGetResults = await _bulletinListGetUseCase.execute(
          BulletinListGetParams(token: Storage().token, type: event.type),
        );

        // declare the bulletins
        var bulletins = bulletinListGetResults.bulletins;
        // if no value or empty, will set the state as BulletinEmpty
        if (bulletins == null || bulletins.isEmpty) {
          emit(BulletinEmpty());
          // else the state will be BulletinListLoaded
        } else {
          // check bulletin is map or not
          if (bulletins is Map) {
            if (bulletins['isMaintenance'] == true) {
              emit(BulletinMaintenanceError(message: bulletins['message']));
            } else {
              BulletinError(error: bulletins['message']);
            }
          } else {
            emit(BulletinListLoaded(bulletins: bulletins));
          }
        }
        // if got error
      } catch (e) {
        if (e is InvalidSessionException) {
          emit(BulletinSessionError(error: e.message));
        } else if (e is InvalidStatusException) {
          emit(BulletinError(error: e.message));
        } else {
          emit(BulletinError(error: e.toString()));
        }
      }
      // else if no internet connection will popup error
    } else {
      emit(BulletinNetworkError(error: 'No internet Connection.'));
    }
  }

  // If BulletinDetailsLoad is called, will call this function
  Future<void> _mapBulletinDetailsLoadEventToState(
    event,
    Emitter<BulletinState> emit,
  ) async {
    emit(BulletinDetailsLoading());

    // check internet connection first
    var internet = await checkInternet();

    // if got internet connection
    if (!internet) {
      try {
        // call get bulletin details API in bulletinDetailsGetUseCase
        var bulletinDetailsGetResults = await _bulletinDetailsGetUseCase
            .execute(
              BulletinDetailsGetParams(
                token: Storage().token,
                bulletinId: event.bulletinId,
              ),
            );

        // declare the details
        var details = bulletinDetailsGetResults.details;

        // if details is null or no value, state will be BulletinDetailsEmpty
        if (details == null) {
          emit(BulletinDetailsEmpty());
          // else state will be BulletinDetailsLoaded
        } else {
          if (details is BulletinDetails) {
            emit(BulletinDetailsLoaded(details: details));
          } else {
            if (details['isMaintenance'] == true) {
              emit(BulletinMaintenanceError(message: details['message']));
            } else {
              BulletinError(error: details['message']);
            }
          }
        }
        // if got error
      } catch (e) {
        if (e is InvalidSessionException) {
          emit(BulletinSessionError(error: e.message));
        } else if (e is InvalidStatusException) {
          emit(BulletinError(error: e.message));
        } else {
          emit(BulletinError(error: e.toString()));
        }
      }
      // else if no internet connection, popup error
    } else {
      emit(BulletinNetworkError(error: 'No internet Connection.'));
    }
  }
}
