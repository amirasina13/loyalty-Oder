import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../../app_setting/app_setting.dart';
import '../../../data/data.dart';
import 'delete_acc.dart';

class DeleteAccBloc extends Bloc<DeleteAccEvent, DeleteAccState> {
  final UserRepository userRepository;

  DeleteAccBloc({required this.userRepository}) : super(DeleteAccInitial()) {
    on<DeleteAccReason>((event, emit) async {
      await _mapDeleteAccReasonEventToState(event.reason, emit);
    });
    // on<DeleteAccMobile>((event, emit) async {
    //   await _mapDeleteAccMobileEventToState(emit);
    // });
    on<DeleteAccSend>((event, emit) async {
      await _mapDeleteAccSendEventToState(event.email, emit);
    });
  }

  Future<bool> checkInternet() async {
    var connectionResult = await Connectivity().checkConnectivity();

    return connectionResult.contains(ConnectivityResult.none);
  }

  // Function to get reason to delete account
  Future<void> _mapDeleteAccReasonEventToState(
    String reason,
    Emitter<DeleteAccState> emit,
  ) async {
    emit(DeleteAccProcessing());

    var internet = await checkInternet();

    if (!internet) {
      try {
        Storage().reasonDelete = reason;

        emit(AccReasonDeleted());
      } catch (e) {
        if (e is InvalidSessionException) {
          emit(DeleteAccError(e.message));
        } else if (e is InvalidStatusException) {
          emit(DeleteAccError(e.message));
        } else {
          emit(DeleteAccError(e.toString()));
        }
      }
    } else {
      emit(VerifyNetworkError('No internet Connection.'));
    }
  }

  // Function send to delete account API
  Future<void> _mapDeleteAccSendEventToState(
    String email,
    Emitter<DeleteAccState> emit,
  ) async {
    emit(DeleteAccProcessing());

    var internet = await checkInternet();

    if (!internet) {
      try {
        var token = Storage().token;
        var reason = Storage().reasonDelete;
        // var mobile = email;

        var accDeleted = await userRepository.deleteAcc(
          token: token,
          reason: reason,
          email: email,
        );

        if (!accDeleted['isMaintenance']) {
          if (accDeleted['status'] == true) {
            // Storage().token = '';
            // Storage().reasonDelete = '';
            // // Storage().mobileDelete = '';

            emit(DeleteAccSent(accDeleted['message']));
          } else {
            emit(DeleteAccError(accDeleted['message']));
          }
        } else {
          emit(DeleteAccMaintenanceError(message: accDeleted['message']));
        }
      } catch (e) {
        if (e is InvalidSessionException) {
          emit(DeleteAccError(e.message));
        } else if (e is InvalidStatusException) {
          emit(DeleteAccError(e.message));
        } else {
          emit(DeleteAccError(e.toString()));
        }
      }
    } else {
      emit(VerifyNetworkError('No internet Connection.'));
    }
  }
}
