import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app_setting/app_setting.dart';
import '../../../data/data.dart';
import 'refer.dart';

class ReferBloc extends Bloc<ReferEvent, ReferState> {
  final UserRepository userRepository;

  ReferBloc({required this.userRepository}) : super(ReferInitial()) {
    on<ReferStart>((event, emit) async {
      emit(ReferInitial());
    });
    on<ReferLoad>((event, emit) async {
      await _mapReferLoadEventToState(event, emit);
    });
  }

  Future<bool> checkInternet() async {
    var connectionResult = await Connectivity().checkConnectivity();

    return connectionResult.contains(ConnectivityResult.none);
  }

  // Function to get referral detail
  Future<void> _mapReferLoadEventToState(
    ReferLoad event,
    Emitter<ReferState> emit,
  ) async {
    var internet = await checkInternet();

    if (!internet) {
      try {
        var userRefer = await userRepository.getBarcodeRefer(
          token: Storage().token,
        );

        if (userRefer is Map) {
          if (userRefer['isMaintenance'] == true) {
            emit(ReferMaintenanceError(message: userRefer['message']));
          } else {
            ReferError(error: userRefer['message']);
          }
        } else {
          emit(ReferLoaded(userRefer: userRefer));
        }
      } catch (e) {
        if (e is InvalidSessionException) {
          emit(ReferSessionError(error: e.message));
        } else if (e is InvalidStatusException) {
          emit(ReferError(error: e.message));
        } else {
          emit(ReferError(error: e.toString()));
        }
      }
    } else {
      emit(ReferNetworkError(error: 'No internet Connection.'));
    }
  }
}
