import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../../app_setting/app_setting.dart';
import '../../../data/data.dart';
import '../../../domain/domain.dart';
import '../../../locator.dart';
import 'outlet.dart';

class OutletBloc extends Bloc<OutletEvent, OutletState> {
  final OutletDetailsGetUseCase _outletDetailsGetUseCase;
  bool isReload = false;

  OutletBloc() : _outletDetailsGetUseCase = sl(), super(OutletInitial()) {
    on<OutletCheck>((event, emit) async {
      if (state is OutletStarted) {
        await _mapOutletCheckEventToState(event, emit);
      } else {
        await _mapOutletCheckEventToState(event, emit);
      }
    });
    on<OutletDetailsLoad>((event, emit) async {
      await _mapOutletDetailsLoadEventToState(event, emit);
    });
    on<OutletLocationEnable>((event, emit) async {
      add(OutletCheck());
    });
    on<OutletLocationDisable>((event, emit) async {
      emit(OutletLocationDisabled());
    });
  }

  Future<bool> checkInternet() async {
    var connectionResult = await Connectivity().checkConnectivity();

    return connectionResult.contains(ConnectivityResult.none);
  }

  // Function to check location enable
  Future<void> _mapOutletCheckEventToState(
    event,
    Emitter<OutletState> emit,
  ) async {
    emit(OutletLoading());
  }

  // Function to get outlet details
  Future<void> _mapOutletDetailsLoadEventToState(
    OutletDetailsLoad event,
    Emitter<OutletState> emit,
  ) async {
    if (!isReload) {
      emit(OutletDetailsLoading());
    }

    var internet = await checkInternet();

    if (!internet) {
      try {
        var outletDetailsGetResults = await _outletDetailsGetUseCase.execute(
          OutletDetailsGetParams(
            outletId: event.outletId,
            token: Storage().token,
          ),
        );

        var details = outletDetailsGetResults.details;

        if (details == null) {
          emit(OutletDetailsEmpty());
        } else {
          if (details is OutletDetails) {
            emit(OutletDetailsLoaded(details: details));
          } else {
            if (details['isMaintenance'] == true) {
              emit(OutletMaintenanceError(message: details['message']));
            } else {
              OutletError(error: details['message']);
            }
          }
        }
      } catch (e) {
        if (e is InvalidSessionException) {
          emit(OutletSessionError(error: e.message));
        } else if (e is InvalidStatusException) {
          emit(OutletError(error: e.message));
        } else {
          emit(OutletError(error: e.toString()));
        }
      }
    } else {
      emit(OutletNetworkError(error: 'No internet Connection.'));
    }
  }
}
