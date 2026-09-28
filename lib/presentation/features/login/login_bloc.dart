import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../../app_setting/app_setting.dart';
import '../../../data/data.dart';
import '../../../domain/domain.dart';
import '../authentication/authentication.dart';
import 'login.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository userRepository;
  final AuthenticationBloc authenticationBloc;

  LoginBloc({required this.userRepository, required this.authenticationBloc})
    : super(LoginInitial()) {
    // on<LoginLoad>((event, emit) async {
    //   await mapLoginLoadToState(event, emit);
    // });
    on<LoginEvent>((event, emit) async {
      await mapEventToState(event, emit);
    });
  }

  // Future<void> mapLoginLoadToState(event, Emitter<LoginState> emit) async {
  //   if (event is LoginLoad) {
  //     // emit(LoginProcessing());
  //     emit(LoginLoaded());
  //   }
  // }

  // Function to login
  Future<void> mapEventToState(event, Emitter<LoginState> emit) async {
    if (event is LoginPressed) {
      emit(LoginProcessing());

      var connectionResult = await Connectivity().checkConnectivity();

      if (connectionResult.contains(ConnectivityResult.none)) {
        emit(LoginNetworkError('No internet Connection.'));
      } else {
        try {
          var pushToken =
              await Storage().secureStorage.read(key: 'push_token') ?? '';
          var userId = event.email ?? event.contact;

          var userEntity = UserEntity(
            id: userId!,
            email: event.email,
            contact: event.contact,
            password: event.password,
            pushToken: pushToken,
          );

          var loginData = await userRepository.login(user: userEntity);

          if (!loginData['isMaintenance']) {
            authenticationBloc.add(
              AuthenticationLoggedIn(
                token: loginData['data']['token'],
                loginData: loginData['data'],
              ),
            );

            emit(LoginFinished(loginData['data']));
          } else {
            emit(LoginMaintenanceError(message: loginData['message']));
          }
        } catch (error) {
          if (error is! String) {
            emit(LoginError(error.toString()));
          } else {
            emit(LoginError(error));
          }
        }
      }
    }
  }
}
