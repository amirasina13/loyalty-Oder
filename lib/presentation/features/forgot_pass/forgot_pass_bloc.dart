import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../../data/data.dart';
import 'forgot_pass.dart';

class ForgotPassBloc extends Bloc<ForgotPassEvent, ForgotPassState> {
  final UserRepository userRepository;

  ForgotPassBloc({required this.userRepository}) : super(ForgotPassInitial()) {
    on<ForgotPassReset>((event, emit) async {
      await _mapForgotPassResetToState(event, emit);
    });
    on<ForgotPassOtpSend>((event, emit) async {
      await _mapForgotPassOtpSendToState(event, emit);
    });
  }

  Future<bool> checkInternet() async {
    var connectionResult = await Connectivity().checkConnectivity();

    return connectionResult.contains(ConnectivityResult.none);
  }

  // Function to send mobile no to forgotPassword API and get otp
  Future<void> _mapForgotPassResetToState(
    ForgotPassReset event,
    Emitter<ForgotPassState> emit,
  ) async {
    emit(ForgotPassProcessing());
    var internet = await checkInternet();

    if (!internet) {
      try {
        var data = await userRepository.forgotPassword(
          email: event.email ?? '',
          contact: event.contact ?? '',
        );

        if (!data['isMaintenance']) {
          if (data['status'] == true) {
            // Storage().otpToken = data['data']['token'];
            // Storage().email = email;

            emit(ForgotPassSent(data));
          } else {
            emit(ForgotPassError(data['message']));
          }
        } else {
          emit(ForgotPassMaintenanceError(message: data['message']));
        }
      } catch (e) {
        if (e is InvalidStatusException) {
          emit(ForgotPassError(e.message));
        } else {
          emit(ForgotPassError(e.toString()));
        }
      }
    } else {
      emit(ForgotPassError('No internet Connection.'));
    }
  }

  // Function to send new password and otpcode to verify password API
  Future<void> _mapForgotPassOtpSendToState(
    ForgotPassOtpSend event,
    Emitter<ForgotPassState> emit,
  ) async {
    emit(ForgotPassProcessing());

    var internet = await checkInternet();

    if (!internet) {
      try {
        var pwReset = await userRepository.verifyPasswordOtp(
          token: event.verifyToken,
          password: event.password,
          otpCode: event.otpCode,
        );

        if (!pwReset['isMaintenance'] && pwReset['status'] == true) {
          // Storage().email = '';
          // Storage().otpToken = '';
          emit(ForgotPassOtpVerified(message: pwReset['message']));
        } else {
          emit(ForgotPassMaintenanceError(message: pwReset['message']));
        }

        // if (pwReset) {
        //   Storage().contact = '';
        //   Storage().otpToken = '';
        //   emit(ForgotPassOtpVerified());
        // }
      } catch (e) {
        if (e is InvalidStatusException) {
          emit(ForgotPassError(e.message));
        } else {
          emit(ForgotPassError(e.toString()));
        }
      }
    } else {
      emit(ForgotPassError('No internet Connection.'));
    }
  }
}
