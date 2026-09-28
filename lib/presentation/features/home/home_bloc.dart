import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../../app_setting/app_setting.dart';
import '../../../data/data.dart';
import 'home.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final UserRepository userRepository;
  final RewardRepository? rewardRepository;

  // Tracking counter for search/clear requests
  int searchGeneration = 0;

  HomeBloc({required this.userRepository, this.rewardRepository})
    : super(HomeInitial()) {
    on<HomeLoad>((event, emit) async {
      await _mapHomeLoadEventToState(emit);
    });
    on<VoucherBrandLoad>((event, emit) async {
      await _mapVoucherBrandLoadEventToState(emit, event);
    });
    on<SearchLoad>((event, emit) async {
      await _mapSearchLoadEventToState(emit, event);
    });
    on<SearchClearLoad>((event, emit) async {
      await _mapSearchClearLoadEventToState(emit, event);
    });
  }

  Future<bool> checkInternet() async {
    var connectionResult = await Connectivity().checkConnectivity();

    return connectionResult.contains(ConnectivityResult.none);
  }

  Future<void> _mapHomeLoadEventToState(Emitter<HomeState> emit) async {
    emit(HomeProcessing());

    var internet = await checkInternet();

    if (!internet) {
      try {
        String token =
            await Storage().secureStorage.read(key: 'push_token') ?? '';

        var homePage = await userRepository.getHomePage(token: Storage().token);

        if (homePage is HomePage) {
          emit(HomeLoaded(token: token, homePage: homePage));
        } else {
          if (homePage['isMaintenance'] == true) {
            emit(HomeMaintenanceError(message: homePage['message']));
          } else {
            HomeError(error: homePage['message']);
          }
        }
      } catch (e) {
        if (e is InvalidSessionException) {
          emit(HomeSessionError(error: e.message));
        } else if (e is InvalidStatusException) {
          emit(HomeError(error: e.message));
        } else {
          emit(HomeError(error: e.toString()));
        }
      }
    } else {
      emit(HomeNetworkError('No internet Connection.'));
    }
  }

  Future<void> _mapVoucherBrandLoadEventToState(
    Emitter<HomeState> emit,
    event,
  ) async {
    emit(HomeProcessing());

    var internet = await checkInternet();

    if (!internet) {
      try {
        var vouchersBrands = await rewardRepository?.searchVouchersBrands(
          token: Storage().token,
          keywords: event.keywords,
        );

        if (vouchersBrands['data'] != null) {
          emit(VoucherBrandLoaded(searchData: vouchersBrands['data']));
        } else if (vouchersBrands['isMaintenance'] == true) {
          emit(HomeMaintenanceError(message: vouchersBrands['message']));
        } else {
          HomeError(error: vouchersBrands['message']);
        }
      } catch (e) {
        if (e is InvalidSessionException) {
          emit(HomeSessionError(error: e.message));
        } else if (e is InvalidStatusException) {
          emit(HomeError(error: e.message));
        } else {
          emit(HomeError(error: e.toString()));
        }
      }
    } else {
      emit(HomeNetworkError('No internet Connection.'));
    }
  }

  Future<void> _mapSearchLoadEventToState(
    Emitter<HomeState> emit,
    event,
  ) async {
    // Increment and capture the local generation for this specific request
    final currentGeneration = ++searchGeneration;

    emit(HomeProcessing());
    var internet = await checkInternet();

    if (!internet) {
      try {
        var searchData = await userRepository.searchFunction(
          token: Storage().token,
          keywords: event.keywords,
          type: event.type,
        );

        // Discard result if a newer search or clear event was triggered while waiting
        if (currentGeneration != searchGeneration || emit.isDone) return;

        if (searchData?.containsKey('data') == true) {
          if (searchData['data'] != null) {
            emit(SearchLoaded(searchData: searchData['data']));
          } else if (searchData['isMaintenance'] == true) {
            emit(HomeMaintenanceError(message: searchData['message']));
          } else {
            emit(HomeError(error: searchData['message']));
          }
        } else {
          emit(SearchEmpty());
        }
      } catch (e) {
        // Discard error state if request is outdated
        if (currentGeneration != searchGeneration || emit.isDone) return;

        if (e is InvalidSessionException) {
          emit(HomeSessionError(error: e.message));
        } else if (e is InvalidStatusException) {
          emit(HomeError(error: e.message));
        } else {
          emit(HomeError(error: e.toString()));
        }
      }
    } else {
      if (currentGeneration != searchGeneration || emit.isDone) return;
      emit(HomeNetworkError('No internet Connection.'));
    }
  }

  Future<void> _mapSearchClearLoadEventToState(
    Emitter<HomeState> emit,
    event,
  ) async {
    // Increment generation to immediately invalidate any pending in-flight search requests
    ++searchGeneration;

    // Clear state instantly without network checks
    emit(SearchClearLoaded());
    // emit(HomeProcessing());

    // var internet = await checkInternet();

    // if (!internet) {
    //   emit(SearchClearLoaded());
    // } else {
    //   emit(HomeNetworkError('No internet Connection.'));
    // }
  }
}
