import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app_setting/app_setting.dart';
import '../../../data/data.dart';
import 'wallet.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final UserRepository userRepository;

  WalletBloc({required this.userRepository}) : super(WalletInitial()) {
    on<WalletStart>((event, emit) async {
      emit(WalletInitial());
    });
    on<WalletLoad>((event, emit) async {
      await _mapWalletLoadEventToState(event, emit);
    });
  }

  Future<bool> checkInternet() async {
    var connectionResult = await Connectivity().checkConnectivity();

    return connectionResult.contains(ConnectivityResult.none);
  }

  // Function to get wallet/ IF card details
  Future<void> _mapWalletLoadEventToState(
    WalletLoad event,
    Emitter<WalletState> emit,
  ) async {
    var internet = await checkInternet();

    if (!internet) {
      try {
        // yield WalletProcessing();
        var wallet = await userRepository.getBarcodeProfile(
          token: Storage().token,
        );

        if (wallet is Map) {
          if (wallet['isMaintenance'] == true) {
            emit(WalletMaintenanceError(message: wallet['message']));
          } else {
            WalletError(error: wallet['message']);
          }
        } else {
          emit(WalletLoaded(userQrcode: wallet));
        }
      } catch (e) {
        if (e is InvalidSessionException) {
          emit(WalletSessionError(error: e.message));
        } else if (e is InvalidStatusException) {
          emit(WalletError(error: e.message));
        } else {
          emit(WalletError(error: e.toString()));
        }
      }
    } else {
      emit(WalletNetworkError(error: 'No internet Connection.'));
    }
  }
}
