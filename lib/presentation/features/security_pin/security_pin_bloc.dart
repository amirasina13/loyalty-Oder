import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../../app_setting/app_setting.dart';
import '../../../data/data.dart';
import '../../../domain/domain.dart';
import '../../../locator.dart';
import 'security_pin.dart';

class SecurityBloc extends Bloc<SecurityEvent, SecurityState> {
  final SecurityGetUseCase _securityGetUseCase;
  final SecurityStartGetUseCase _securityStartGetUseCase;
  final SecurityVerifyOtpGetUseCase _securityVerifyOtpGetUseCase;
  final SecurityCreatePinGetUseCase _securityCreatePinGetUseCase;
  final SecurityVerifyPinGetUseCase _securityVerifyPinGetUseCase;

  SecurityBloc()
    : _securityGetUseCase = sl(),
      _securityStartGetUseCase = sl(),
      _securityVerifyOtpGetUseCase = sl(),
      _securityCreatePinGetUseCase = sl(),
      _securityVerifyPinGetUseCase = sl(),
      super(SecurityInitial()) {
    on<SecurityStart>((event, emit) async {
      await _mapSecurityCheckEventToState(event, emit);
    });
    on<SecurityOtpSend>((event, emit) async {
      await _mapSecurityOtpSendEventToState(event, emit);
    });
    on<SecurityOtpVerify>((event, emit) async {
      await _mapSecurityOtpVerifyEventToState(event, emit);
    });
    on<SecurityCreatePin>((event, emit) async {
      await _mapSecurityCreatePinEventToState(event, emit);
    });
    on<SecurityPinVerify>((event, emit) async {
      await _mapSecurityVerifyPinEventToState(event, emit);
    });
    on<SecurityOtpResend>((event, emit) async {
      await _mapSecurityOtpResendEventToState(event, emit);
    });
  }

  Future<bool> checkInternet() async {
    var connectionResult = await Connectivity().checkConnectivity();

    return connectionResult.contains(ConnectivityResult.none);
  }

  // Function to check if have security pin or not
  Future<void> _mapSecurityCheckEventToState(
    SecurityStart event,
    Emitter<SecurityState> emit,
  ) async {
    emit(SecurityProcessing());

    var internet = await checkInternet();

    if (!internet) {
      try {
        var securityGetResults = await _securityGetUseCase.execute(
          SecurityGetParams(token: Storage().token),
        );

        var verified = securityGetResults.security;

        if (verified is bool) {
          emit(SecurityCheckVerified(verified: verified));
        } else {
          if (verified['isMaintenance'] == true) {
            emit(SecurityMaintenanceError(message: verified['message']));
          } else {
            SecurityError(verified['message']);
          }
        }
      } catch (e) {
        if (e is InvalidSessionException) {
          emit(SecuritySessionError(error: e.message));
        } else if (e is InvalidStatusException) {
          emit(SecurityError(e.message));
        } else {
          emit(SecurityError(e.toString()));
        }
      }
    } else {
      emit(SecurityNetworkError('No internet Connection.'));
    }
  }

  // Function to send otp
  Future<void> _mapSecurityOtpSendEventToState(
    SecurityOtpSend event,
    Emitter<SecurityState> emit,
  ) async {
    emit(SecurityProcessing());

    var internet = await checkInternet();

    if (!internet) {
      try {
        var securityStartGetResults = await _securityStartGetUseCase.execute(
          SecurityStartGetParams(token: Storage().token),
        );

        var securityOtp = securityStartGetResults.securityOtp;

        if (securityOtp['isMaintenance'] == true) {
          emit(SecurityMaintenanceError(message: securityOtp['message']));
        } else {
          // Storage().otpToken = securityOtp['data']['otp_token'];
          emit(SecurityOtpSent(securityOtp));
        }
      } catch (e) {
        if (e is InvalidSessionException) {
          emit(SecuritySessionError(error: e.message));
        } else if (e is InvalidStatusException) {
          emit(SecurityError(e.message));
        } else {
          emit(SecurityError(e.toString()));
        }
      }
    } else {
      emit(SecurityNetworkError('No internet Connection.'));
    }
  }

  // Function to verify otp
  Future<void> _mapSecurityOtpVerifyEventToState(
    SecurityOtpVerify event,
    Emitter<SecurityState> emit,
  ) async {
    emit(SecurityProcessing());

    var internet = await checkInternet();

    if (!internet) {
      try {
        var securityStartGetResults = await _securityVerifyOtpGetUseCase
            .execute(
              SecurityVerifyOtpGetParams(
                token: Storage().token,
                otp: event.otp,
                otpToken: event.otpToken,
              ),
            );

        var isVerified = securityStartGetResults.securityOtp;

        if (isVerified['isMaintenance'] == true) {
          emit(SecurityMaintenanceError(message: isVerified['message']));
        } else {
          if (isVerified['status'] == true) {
            Storage().otp = event.otp;
            Storage().otpToken = event.otpToken;

            emit(SecurityOtpVerified(isVerified));
          } else {
            emit(SecurityError(isVerified['message']));
          }
        }
      } catch (e) {
        if (e is InvalidSessionException) {
          emit(SecuritySessionError(error: e.message));
        } else if (e is InvalidStatusException) {
          emit(SecurityError(e.message));
        } else {
          emit(SecurityError(e.toString()));
        }
      }
    } else {
      emit(SecurityNetworkError('No internet Connection.'));
    }
  }

  // Function to create security pin
  Future<void> _mapSecurityCreatePinEventToState(
    SecurityCreatePin event,
    Emitter<SecurityState> emit,
  ) async {
    emit(SecurityProcessing());

    var internet = await checkInternet();

    if (!internet) {
      try {
        var securityCreatePinGetResults = await _securityCreatePinGetUseCase
            .execute(
              SecurityCreatePinGetParams(
                token: Storage().token,
                otpToken: Storage().otpToken,
                otp: Storage().otp,
                pin: event.pin,
              ),
            );

        var isCreated = securityCreatePinGetResults.createPin;

        if (isCreated['isMaintenance'] == true) {
          emit(SecurityMaintenanceError(message: isCreated['message']));
        } else {
          if (isCreated['status'] == true) {
            // Storage().otp = event.otp;
            emit(SecurityPinCreated(isCreated));
          } else {
            emit(SecurityError(isCreated['message']));
          }
        }
      } catch (e) {
        if (e is InvalidSessionException) {
          emit(SecuritySessionError(error: e.message));
        } else if (e is InvalidStatusException) {
          emit(SecurityError(e.message));
        } else {
          emit(SecurityError(e.toString()));
        }
      }
    } else {
      emit(SecurityNetworkError('No internet Connection.'));
    }
  }

  // Function to verify security pin
  Future<void> _mapSecurityVerifyPinEventToState(
    SecurityPinVerify event,
    Emitter<SecurityState> emit,
  ) async {
    emit(SecurityProcessing());

    var internet = await checkInternet();

    if (!internet) {
      try {
        var securityPinGetResults = await _securityVerifyPinGetUseCase.execute(
          SecurityVerifyPinGetParams(token: Storage().token, pin: event.pin),
        );

        var verified = securityPinGetResults.data;

        if (verified['isMaintenance'] == true) {
          emit(SecurityMaintenanceError(message: verified['message']));
        } else {
          if (verified['status'] == true) {
            Storage().securityPin = event.pin;
            emit(SecurityPinVerified(verified));
          } else {
            emit(SecurityError(verified['message']));
          }
        }
      } catch (e) {
        if (e is InvalidSessionException) {
          emit(SecuritySessionError(error: e.message));
        } else if (e is InvalidStatusException) {
          emit(SecurityError(e.message));
        } else {
          emit(SecurityError(e.toString()));
        }
      }
    } else {
      emit(SecurityNetworkError('No internet Connection.'));
    }
  }

  // Function to regenerate otp
  Future<void> _mapSecurityOtpResendEventToState(
    SecurityOtpResend event,
    Emitter<SecurityState> emit,
  ) async {
    emit(VerifyPinProcessing());

    var internet = await checkInternet();

    if (!internet) {
      try {
        var securityStartGetResults = await _securityStartGetUseCase.execute(
          SecurityStartGetParams(token: Storage().token),
        );

        var securityOtp = securityStartGetResults.securityOtp;
        // Storage().otpToken = securityOtp['data']['otp_token'];

        if (securityOtp['isMaintenance'] == true) {
          emit(SecurityMaintenanceError(message: securityOtp['message']));
        } else {
          emit(SecurityOtpSent(securityOtp));
        }
      } catch (e) {
        if (e is InvalidSessionException) {
          emit(SecuritySessionError(error: e.message));
        } else if (e is InvalidStatusException) {
          emit(SecurityError(e.message));
        } else {
          emit(SecurityError(e.toString()));
        }
      }
    } else {
      emit(SecurityNetworkError('No internet Connection.'));
    }
  }
}
