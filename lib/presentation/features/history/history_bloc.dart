import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../../app_setting/app_setting.dart';
import '../../../data/data.dart';
import '../../../domain/domain.dart';
import '../../../locator.dart';
import 'history.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final HistoryTransactionsGetUseCase _historyTransactionsGetUseCase;
  final CreditHistoryTransactionsGetUseCase
  _creditHistoryTransactionsGetUseCase;
  final WalletCreditHistoryTransactionsGetUseCase
  _walletCreditHistoryTransactionsGetUseCase;

  int page = 0, creditPage = 0;
  bool isFetching = false,
      isCreditFetching = false,
      isFirstShow = true,
      isFirstShowPoint = true;
  List<Records> records = [];
  List<CreditRecords> creditRecords = [];

  HistoryBloc()
    : _historyTransactionsGetUseCase = sl(),
      _creditHistoryTransactionsGetUseCase = sl(),
      _walletCreditHistoryTransactionsGetUseCase = sl(),
      super(HistoryInitial()) {
    on<HistoryTransactionsLoad>((event, emit) async {
      await _mapHistoryTransactionsLoadEventToState(emit);
    });
    on<CreditHistoryTransactionsLoad>((event, emit) async {
      await _mapCreditHistoryTransactionsLoadEventToState(emit);
    });
    on<WalletCreditHistoryTransactionsLoad>((event, emit) async {
      await _mapWalletCreditHistoryTransactionsLoadEventToState(event, emit);
    });
  }

  Future<bool> checkInternet() async {
    var connectionResult = await Connectivity().checkConnectivity();

    return connectionResult.contains(ConnectivityResult.none);
  }

  // Function to get list of transaction history for points
  Future<void> _mapHistoryTransactionsLoadEventToState(
    Emitter<HistoryState> emit,
  ) async {
    if (isFetching == false) {
      emit(HistoryLoading());
    } else {
      emit(HistoryPointNextLoading());
    }

    var internet = await checkInternet();

    if (!internet) {
      if (isFirstShowPoint == true) {
        page = 0;
      }

      try {
        var historyTransactionsGetResults = await _historyTransactionsGetUseCase
            .execute(
              HistoryTransactionsGetParams(token: Storage().token, page: page),
            );

        var history = historyTransactionsGetResults.history;

        if (history is History) {
          if (history.records == null || history.records!.isEmpty) {
            if (page == 0) {
              emit(HistoryEmpty());
            } else {
              emit(HistoryListStop());
            }
          } else {
            // page += AppSettings.limit;

            final startIndex = history.next!.indexOf('=');
            final endIndex = history.next!.indexOf(
              '&',
              startIndex + '='.length,
            );

            page = int.parse(
              history.next!.substring(startIndex + '='.length, endIndex),
            );

            emit(HistoryTransactionsLoaded(history: history));
          }
        } else {
          emit(HistoryMaintenanceError(message: history['message']));
        }
      } catch (e) {
        if (e is InvalidSessionException) {
          emit(HistorySessionError(error: e.message));
        } else if (e is InvalidStatusException) {
          emit(HistoryError(error: e.message));
        } else {
          emit(HistoryError(error: e.toString()));
        }
      }
    } else {
      emit(HistoryNetworkError(error: 'No internet Connection.'));
    }
  }

  // Function to get list of transaction history for credits
  Future<void> _mapCreditHistoryTransactionsLoadEventToState(
    Emitter<HistoryState> emit,
  ) async {
    if (isCreditFetching == false) {
      emit(HistoryLoading());
    } else {
      emit(HistoryCreditNextLoading());
    }

    var internet = await checkInternet();

    if (!internet) {
      if (isFirstShow == true) {
        creditPage = 0;
      }

      try {
        var credithistoryTransactionsGetResults =
            await _creditHistoryTransactionsGetUseCase.execute(
              CreditHistoryTransactionsGetParams(
                token: Storage().token,
                page: creditPage,
              ),
            );

        var history = credithistoryTransactionsGetResults.history;

        if (history is CreditHistory) {
          if (history.records == null || history.records!.isEmpty) {
            if (creditPage == 0) {
              emit(CreditHistoryEmpty());
            } else {
              emit(CreditHistoryListStop());
            }
          } else {
            final startIndex = history.next!.indexOf('=');
            final endIndex = history.next!.indexOf(
              '&',
              startIndex + '='.length,
            );

            creditPage = int.parse(
              history.next!.substring(startIndex + '='.length, endIndex),
            );

            emit(CreditHistoryTransactionsLoaded(history: history));
          }
        } else {
          emit(HistoryMaintenanceError(message: history['message']));
        }
      } catch (e) {
        if (e is InvalidSessionException) {
          emit(HistorySessionError(error: e.message));
        } else if (e is InvalidStatusException) {
          emit(HistoryError(error: e.message));
        } else {
          emit(HistoryError(error: e.toString()));
        }
      }
    } else {
      emit(HistoryNetworkError(error: 'No internet Connection.'));
    }
  }

  // Function to get list of transaction history for credits and show in IF Card page
  Future<void> _mapWalletCreditHistoryTransactionsLoadEventToState(
    event,
    Emitter<HistoryState> emit,
  ) async {
    if (isCreditFetching == false) {
      emit(HistoryLoading());
    } else {
      emit(HistoryCreditNextLoading());
    }
    var internet = await checkInternet();

    if (!internet) {
      if (isFirstShow == true) {
        final startIndex = event.offset.indexOf('=');
        final endIndex = event.offset.indexOf('&', startIndex + '='.length);

        creditPage = int.parse(
          event.offset.substring(startIndex + '='.length, endIndex),
        );
      }

      try {
        var walletCredithistoryTransactionsGetResults =
            await _walletCreditHistoryTransactionsGetUseCase.execute(
              WalletCreditHistoryTransactionsGetParams(
                token: Storage().token,
                page: creditPage,
              ),
            );

        var historyWallet = walletCredithistoryTransactionsGetResults.history;

        if (historyWallet is CreditHistory) {
          if (historyWallet.records == null || historyWallet.records!.isEmpty) {
            emit(CreditHistoryListStop());
          } else {
            final startIndex = historyWallet.next!.indexOf('=');
            final endIndex = historyWallet.next!.indexOf(
              '&',
              startIndex + '='.length,
            );

            creditPage = int.parse(
              historyWallet.next!.substring(startIndex + '='.length, endIndex),
            );

            emit(WalletCreditHistoryTransactionsLoaded(history: historyWallet));
          }
        } else {
          emit(HistoryMaintenanceError(message: historyWallet['message']));
        }
      } catch (e) {
        if (e is InvalidSessionException) {
          emit(HistorySessionError(error: e.message));
        } else if (e is InvalidStatusException) {
          emit(HistoryError(error: e.message));
        } else {
          emit(HistoryError(error: e.toString()));
        }
      }
    } else {
      emit(HistoryNetworkError(error: 'No internet Connection.'));
    }
  }
}
