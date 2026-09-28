import 'package:bloc/bloc.dart';

import '../../../app_setting/app_setting.dart';
import '../../../data/data.dart';
import 'otp.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  final UserRepository userRepository;

  OtpBloc({required this.userRepository}) : super(OtpInitial()) {
    on<OtpEvent>((event, emit) async {
      await mapEventToState(event, emit);
    });
  }

  // Function to verify otp and regenerate otp
  Future<void> mapEventToState(OtpEvent event, Emitter<OtpState> emit) async {
    if (event is OtpRequest) {
      emit(OtpProcessing());

      try {
        var data = await userRepository.generateOtp(
          method: event.method,
          sendVia: event.sendvia,
          purpose: event.purpose,
          vToken: event.vToken,
        );

        if (!data['isMaintenance']) {
          if (data['status'] == true) {
            // Storage().otpToken = data['data']['token'];
            emit(OtpRequestSuccess(data));
          } else {
            emit(OtpError(data['message']));
          }
        } else {
          emit(OtpMaintenanceError(message: data['message']));
        }
      } catch (e) {
        if (e is InvalidStatusException) {
          emit(OtpError(e.message));
        } else {
          emit(OtpError(e.toString()));
        }
      }
    } else if (event is OtpVerify) {
      emit(OtpProcessing());
      try {
        // var token = Storage().otpToken;
        var verifiedOtp = await userRepository.verifyOtp(
          token: event.token,
          otpCode: event.otpCode,
        );

        if (verifiedOtp['status'] == true) {
          // Storage().contact = '';
          // Storage().otpToken = '';
          emit(OtpFinished(verifiedOtp['message']));
        }
      } catch (e) {
        if (e is InvalidStatusException) {
          emit(OtpError(e.message));
        } else if (e is String) {
          emit(OtpError(e));
        } else {
          emit(OtpError(e.toString()));
        }
      }
    } else if (event is OtpResend) {
      emit(OtpProcessing());

      try {
        var data = await userRepository.generateOtp(
          method: event.method,
          sendVia: event.sendvia,
          purpose: event.purpose,
          vToken: event.vToken,
        );

        if (!data['isMaintenance']) {
          if (data['status'] == true) {
            Storage().otpToken = data['data']['token'];
            emit(OtpResent(data));
          } else {
            emit(OtpError(data['message']));
          }
        } else {
          emit(OtpMaintenanceError(message: data['message']));
        }
      } catch (e) {
        if (e is InvalidStatusException) {
          emit(OtpError(e.message));
        } else {
          emit(OtpError(e.toString()));
        }
      }

      emit(OtpInitial());
    }
  }
}
