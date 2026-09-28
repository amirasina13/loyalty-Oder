import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../../data/data.dart';
import 'register.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UserRepository userRepository;

  RegisterBloc({required this.userRepository}) : super(RegisterInitial()) {
    on<RegisterVerify>((event, emit) async {
      await _mapRegisterVerifyToState(event, emit);
    });
    on<RegisterPressed>((event, emit) async {
      await _mapRegisterToState(event, emit);
    });
    on<RegisterReferDecrypt>((event, emit) async {
      await _mapRegisterReferDecryptToState(event, emit);
    });
  }

  Future<bool> checkInternet() async {
    var connectionResult = await Connectivity().checkConnectivity();

    return connectionResult.contains(ConnectivityResult.none);
  }

  // Function to verify register
  Future<void> _mapRegisterVerifyToState(
    RegisterVerify event,
    Emitter<RegisterState> emit,
  ) async {
    // normal register
    emit(RegisterProcessing());

    var internet = await checkInternet();

    if (!internet) {
      try {
        final data = await userRepository.verifyRegister(
          email: event.email,
          contact: event.contact,
        );

        if (data['isMaintenance'] == true) {
          emit(RegisterMaintenanceError(message: data['message']));
        } else {
          if (data['status'] == true) {
            emit(RegisterVerifySuccess(data));
          } else {
            emit(RegisterError(data['message']));
          }
        }
      } catch (error) {
        if (error is String) {
          emit(RegisterError(error));
        } else if (error is InvalidStatusException) {
          emit(RegisterError(error.toString()));
        } else {
          emit(RegisterError(error.toString()));
        }
      }
    } else {
      emit(RegisterNetworkError('No internet Connection.'));
    }
  }

  // Function to register user
  Future<void> _mapRegisterToState(
    RegisterPressed event,
    Emitter<RegisterState> emit,
  ) async {
    // normal register
    emit(RegisterProcessing());

    var internet = await checkInternet();

    if (!internet) {
      try {
        final data = await userRepository.register(
          email: event.email,
          contact: event.contact,
          password: event.password,
          referral: event.referral,
          vToken: event.vToken,
        );

        if (!data['isMaintenance']) {
          if (data['status'] == true) {
            // Storage().otpToken = data['data']['token'];
            // Storage().email = event.email;
            emit(RegisterSuccess(data));
          } else {
            emit(RegisterError(data['message']));
          }
        } else {
          emit(RegisterMaintenanceError(message: data['message']));
        }
      } catch (error) {
        if (error is String) {
          emit(RegisterError(error));
        } else if (error is InvalidStatusException) {
          emit(RegisterError(error.toString()));
        } else {
          emit(RegisterError(error.toString()));
        }
      }
    } else {
      emit(RegisterNetworkError('No internet Connection.'));
    }
  }

  // Function to decrypt refferal code
  Future<void> _mapRegisterReferDecryptToState(
    RegisterReferDecrypt event,
    Emitter<RegisterState> emit,
  ) async {
    emit(RegisterProcessing());

    var internet = await checkInternet();

    if (!internet) {
      try {
        final referCode = await userRepository.getReferCode(
          referCode: event.referCode,
        );

        if (referCode != '') {
          emit(ReferDecryptSuccess(referCode: referCode));
        } else {
          emit(ReferDecryptFail());
        }
      } catch (error) {
        if (error is String) {
          emit(RegisterError(error));
        } else if (error is InvalidStatusException) {
          emit(RegisterError(error.toString()));
        } else {
          emit(RegisterError(error.toString()));
        }
      }
    } else {
      emit(RegisterNetworkError('No internet Connection.'));
    }
  }
}
