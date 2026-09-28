import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../../app_setting/app_setting.dart';
import '../../../data/data.dart';
import 'setup.dart';

class SetupBloc extends Bloc<SetupEvent, SetupState> {
  final UserRepository userRepository;

  SetupBloc({required this.userRepository}) : super(SetupInitial()) {
    on<SetupEmail>((event, emit) async {
      await _mapSetupEmailEventToState(event, emit);
    });
    on<SetupContact>((event, emit) async {
      await _mapSetupContactEventToState(event, emit);
    });
    on<SetupMuslimFriendly>((event, emit) async {
      await _mapSetupMuslimFriendlyEventToState(event, emit);
    });
    on<SetupVerify>((event, emit) async {
      await _mapSetupVerifyOtpEventToState(event, emit);
    });
    on<SetupResend>((event, emit) async {
      await _mapSetupResendEventToState(event, emit);
    });
  }

  Future<bool> checkInternet() async {
    var connectionResult = await Connectivity().checkConnectivity();

    return connectionResult.contains(ConnectivityResult.none);
  }

  // Function to update email (setup)
  Future<void> _mapSetupEmailEventToState(
    event,
    Emitter<SetupState> emit,
  ) async {
    emit(SetupProcessing());

    var internet = await checkInternet();

    if (!internet) {
      try {
        var data = await userRepository.updateEmail(
          token: Storage().token,
          email: event.email,
        );

        if (!data['isMaintenance']) {
          if (data.containsKey('data')) {
            emit(SetupEmailOtp(data));
          } else {
            emit(SetupEmailDone(data));
          }
        } else {
          emit(SetupMaintenanceError(message: data['message']));
        }
      } catch (e) {
        if (e is InvalidStatusException) {
          emit(SetupError(e.message));
        } else {
          emit(SetupError(e.toString()));
        }
      }
    } else {
      emit(SetupNetworkError(error: 'No internet Connection.'));
    }
  }

  // Function to update contact (setup)
  Future<void> _mapSetupContactEventToState(
    event,
    Emitter<SetupState> emit,
  ) async {
    emit(SetupProcessing());

    var internet = await checkInternet();

    if (!internet) {
      try {
        var data = await userRepository.updateContact(
          token: Storage().token,
          contact: event.contact,
        );

        if (!data['isMaintenance']) {
          if (data.containsKey('data')) {
            Storage().otpToken = data['data']['token'];
            emit(SetupContactOtp(data));
          } else {
            emit(SetupContactDone(data));
          }
        } else {
          emit(SetupMaintenanceError(message: data['message']));
        }
      } catch (e) {
        if (e is InvalidStatusException) {
          emit(SetupError(e.message));
        } else {
          emit(SetupError(e.toString()));
        }
      }
    } else {
      emit(SetupNetworkError(error: 'No internet Connection.'));
    }
  }

  // Function to update muslim friendly (setup)
  Future<void> _mapSetupMuslimFriendlyEventToState(
    event,
    Emitter<SetupState> emit,
  ) async {
    emit(SetupProcessing());

    var internet = await checkInternet();

    if (!internet) {
      try {
        var data = await userRepository.updateMuslimFriendly(
          token: Storage().token,
          isMuslim: event.isMuslim,
        );

        if (!data['isMaintenance']) {
          emit(SetupMuslimFriendlyDone(data));
        } else {
          emit(SetupMaintenanceError(message: data['message']));
        }
      } catch (e) {
        if (e is InvalidStatusException) {
          emit(SetupError(e.message));
        } else {
          emit(SetupError(e.toString()));
        }
      }
    } else {
      emit(SetupNetworkError(error: 'No internet Connection.'));
    }
  }

  // Function to verify otp
  Future<void> _mapSetupVerifyOtpEventToState(
    event,
    Emitter<SetupState> emit,
  ) async {
    emit(SetupProcessing());

    var internet = await checkInternet();

    if (!internet) {
      try {
        var token = Storage().otpToken;
        var verifiedOtp = await userRepository.verifyOtp(
          token: token,
          otpCode: event.otpCode,
        );

        if (verifiedOtp['isMaintenance'] == true) {
          emit(SetupMaintenanceError(message: verifiedOtp['message']));
        } else {
          if (verifiedOtp['status'] == true) {
            // Storage().contact = '';
            // Storage().otpToken = '';
            emit(SetupFinished(verifiedOtp));
          } else {
            emit(SetupError(verifiedOtp['message']));
          }
        }
      } catch (e) {
        if (e is InvalidStatusException) {
          emit(SetupError(e.message));
        } else if (e is String) {
          emit(SetupError(e));
        } else {
          emit(SetupError(e.toString()));
        }
      }
    } else {
      emit(SetupNetworkError(error: 'No internet Connection.'));
    }
  }

  // Function to regenerate otp again
  Future<void> _mapSetupResendEventToState(
    event,
    Emitter<SetupState> emit,
  ) async {
    emit(SetupProcessing());

    var internet = await checkInternet();

    if (!internet) {
      try {
        var otpToken = await userRepository.generateOtp(
          method:
              event
                  .contactNo, // ----------------------------------------------------------- change
          sendVia: 'contact',
          purpose: event.purpose,
          vToken:
              event
                  .vToken, // ----------------------------------------------------------- change
        );

        if (!otpToken['isMaintenance']) {
          Storage().otpToken = otpToken['data']['token'];

          if (otpToken['status'] == true) {
            Storage().otpToken = otpToken['data']['token'];
            emit(SetupSent(otpToken));
          }
        } else {
          emit(SetupMaintenanceError(message: otpToken['message']));
        }
      } catch (e) {
        if (e is InvalidStatusException) {
          emit(SetupError(e.message));
        } else {
          emit(SetupError(e.toString()));
        }
      }

      emit(SetupInitial());
    } else {
      emit(SetupNetworkError(error: 'No internet Connection.'));
    }
  }
}
