import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../../app_setting/app_setting.dart';
import '../../../data/data.dart';
import 'verify_email.dart';

class VerifyEmailBloc extends Bloc<VerifyEmailEvent, VerifyEmailState> {
  final UserRepository userRepository;

  VerifyEmailBloc({required this.userRepository})
    : super(VerifyEmailInitial()) {
    on<VerifyEmailSend>((event, emit) async {
      await _mapVerifyEmailSendEventToState(event, emit);
    });
    on<VerifyEmailOtpSend>((event, emit) async {
      await _mapVerifyEmailOtpSendEventToState(event, emit);
    });
    on<VerifyEmailOtpResend>((event, emit) async {
      await _mapVerifyEmailOtpResendEventToState(event, emit);
    });
  }

  Future<bool> checkInternet() async {
    var connectionResult = await Connectivity().checkConnectivity();

    return connectionResult.contains(ConnectivityResult.none);
  }

  // Function to verify email
  Future<void> _mapVerifyEmailSendEventToState(
    VerifyEmailSend event,
    Emitter<VerifyEmailState> emit,
  ) async {
    emit(VerifyEmailProcessing());

    var internet = await checkInternet();

    if (!internet) {
      try {
        var data = await userRepository.sendEmailVerify(
          token: Storage().token,
          email: event.email,
        );

        if (!data['isMaintenance']) {
          Storage().otpToken = data['data']['token'];
          Storage().email = event.email;

          emit(VerifyEmailSent(data));
        } else {
          emit(VerifyEmailMaintenanceError(message: data['message']));
        }
      } catch (e) {
        if (e is InvalidSessionException) {
          emit(VerifyEmailError(e.message));
        } else if (e is InvalidStatusException) {
          emit(VerifyEmailError(e.message));
        } else {
          emit(VerifyEmailError(e.toString()));
        }
      }
    } else {
      emit(VerifyNetworkError('No internet Connection.'));
    }
  }

  // Function to verify otp for email
  Future<void> _mapVerifyEmailOtpSendEventToState(
    VerifyEmailOtpSend event,
    Emitter<VerifyEmailState> emit,
  ) async {
    emit(VerifyEmailProcessing());

    var internet = await checkInternet();

    if (!internet) {
      try {
        var token = Storage().otpToken;
        var verifiedOtp = await userRepository.verifyOtp(
          token: token,
          otpCode: event.otpCode,
        );

        if (!verifiedOtp['isMaintenance']) {
          if (verifiedOtp['status'] == true) {
            Storage().email = '';
            Storage().otpToken = '';
            emit(VerifyEmailOtpVerified(verifiedOtp));
          } else {
            emit(VerifyEmailError(verifiedOtp['message']));
          }
        } else {
          emit(VerifyEmailMaintenanceError(message: verifiedOtp['message']));
        }
      } catch (e) {
        if (e is InvalidSessionException) {
          emit(VerifyEmailError(e.message));
        } else if (e is InvalidStatusException) {
          emit(VerifyEmailError(e.message));
        } else {
          emit(VerifyEmailError(e.toString()));
        }
      }
    } else {
      emit(VerifyNetworkError('No internet Connection.'));
    }
  }

  // Function to regenerate otp for email
  Future<void> _mapVerifyEmailOtpResendEventToState(
    VerifyEmailOtpResend event,
    Emitter<VerifyEmailState> emit,
  ) async {
    emit(VerifyEmailProcessing());

    var internet = await checkInternet();

    if (!internet) {
      try {
        var data = await userRepository.generateOtp(
          method:
              event
                  .contactNo, // ----------------------------------------------------------- change
          sendVia: 'contact',
          purpose: event.purpose,
          vToken:
              event
                  .vToken, // ----------------------------------------------------------- change
        );

        if (!data['isMaintenance']) {
          Storage().otpToken = data['data']['token'];
          emit(VerifyEmailSent(data));
        } else {
          emit(VerifyEmailMaintenanceError(message: data['message']));
        }
      } catch (e) {
        if (e is InvalidSessionException) {
          emit(VerifyEmailError(e.message));
        } else if (e is InvalidStatusException) {
          emit(VerifyEmailError(e.message));
        } else {
          emit(VerifyEmailError(e.toString()));
        }
      }
    } else {
      emit(VerifyNetworkError('No internet Connection.'));
    }
  }
}
