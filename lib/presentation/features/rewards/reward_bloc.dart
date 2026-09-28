import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart' as geoloc;
import 'package:intl/intl.dart';
import 'package:location/location.dart';

import '../../../app_setting/app_setting.dart';
import '../../../data/data.dart';
import '../../../domain/domain.dart';
import '../../../locator.dart';
import 'reward.dart';

class RewardBloc extends Bloc<RewardEvent, RewardState> {
  final RewardListGetUseCase _rewardListGetUseCase;
  final RewardMerchantGetUseCase _rewardMerchantGetUseCase;
  final RewardDetailsGetUseCase _rewardDetailsGetUseCase;
  final RewardDetailsDynamicGetUseCase _rewardDetailsDynamicGetUseCase;
  final RewardDownloadGetUseCase _rewardDownloadGetUseCase;
  final RewardPurchaseGetUseCase _rewardPurchaseGetUseCase;
  final OutletDetailsGetUseCase _outletDetailsGetUseCase;
  final RewardRedeemQrGetUseCase _rewardRedeemQrGetUseCase;
  final FilterCategoryGetUseCase _filterCategoryGetUseCase;
  final RewardRepository? rewardRepository;
  final BuildContext? context;

  Location? _location;
  geoloc.Position? _currentLoc;
  String? currentLatitude, currentLongitude;
  var now = DateTime.now();
  var format = DateFormat('yyyy-MM-dd');
  late String dateNow = format.format(now);
  geoloc.LocationAccuracyStatus? accuracy;
  // bool isReload = false;
  int rewardPage = 0;
  bool isRewardFetching = false;
  bool isReload = false;
  bool isRedeemingQr = false;

  initialize() async {
    _location ??= Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _location!.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location!.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await _location!.hasPermission();

    await geoloc.Geolocator.getLocationAccuracy()
        .then((value) {
          if (value == geoloc.LocationAccuracyStatus.reduced) {
            accuracy = geoloc.LocationAccuracyStatus.reduced;
          }
        })
        .catchError((e) {});

    if (permissionGranted == PermissionStatus.denied ||
        permissionGranted == PermissionStatus.deniedForever ||
        permissionGranted == PermissionStatus.grantedLimited) {
      if (accuracy != geoloc.LocationAccuracyStatus.reduced &&
          accuracy != geoloc.LocationAccuracyStatus.precise) {
        permissionGranted = await _location!.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          return;
        }
      }
    }

    // if (permissionGranted == PermissionStatus.denied) {
    //   permissionGranted = await _location!.requestPermission();
    //   if (permissionGranted != PermissionStatus.granted) {
    //     return;
    //   }
    // }

    if (Storage().latitude!.isNotEmpty && Storage().longitude!.isNotEmpty) {
      currentLatitude = Storage().latitude;
      currentLongitude = Storage().longitude;
    } else {
      _currentLoc = await _getCurrentLocation();
      if (_currentLoc != null) {
        currentLatitude = _currentLoc!.latitude.toString();
        currentLongitude = _currentLoc!.longitude.toString();
      }
    }
  }

  RewardBloc({required this.context, required this.rewardRepository})
    : _rewardListGetUseCase = sl(),
      _rewardMerchantGetUseCase = sl(),
      _rewardDetailsGetUseCase = sl(),
      _rewardDetailsDynamicGetUseCase = sl(),
      _rewardDownloadGetUseCase = sl(),
      _rewardPurchaseGetUseCase = sl(),
      _outletDetailsGetUseCase = sl(),
      _rewardRedeemQrGetUseCase = sl(),
      _filterCategoryGetUseCase = sl(),
      super(RewardInitial()) {
    on<RewardOutletCheck>((event, emit) async {
      if (state is RewardOutletStarted) {
        await _mapOutletCheckEventToState(event, emit);
      } else {
        await _mapOutletCheckEventToState(event, emit);
      }
    });
    on<RewardReload>((event, emit) async {
      await _mapRewardReloadEventToState(event, emit);
    });
    on<RewardScannerLoad>((event, emit) async {
      await _mapRewardScannerLoadEventToState(event, emit);
    });
    on<RewardMerchantLoad>((event, emit) async {
      await _mapRewardMerchantLoadEventToState(event, emit);
    });
    on<FilterCategoryLoad>((event, emit) async {
      await _mapFilterCategoryLoadEventToState(event, emit);
    });
    on<RewardListLoad>((event, emit) async {
      await _mapRewardListLoadEventToState(event, emit);
    });
    // on<RewardFilterListLoad>((event, emit) async {
    //   await _mapRewardFilterListLoadEventToState(event, emit);
    // });
    on<RewardDetailsLoad>((event, emit) async {
      await _mapRewardDetailsLoadEventToState(event, emit);
    });
    on<RewardDetailsDynamicLoad>((event, emit) async {
      await _mapRewardDetailsDynamicLoadEventToState(event, emit);
    });
    on<RewardDownload>((event, emit) async {
      await _mapRewardDownloadEventToState(event, emit);
    });
    on<RewardPurchaseLoad>((event, emit) async {
      await _mapRewardPurchaseLoadEventToState(event, emit);
    });
    on<RewardOutletDetailsLoad>((event, emit) async {
      await _mapRewardOutletDetailsLoadEventToState(event, emit);
    });
    on<RewardRedeemQrLoad>((event, emit) async {
      await _mapRewardRedeemQrLoadEventToState(event, emit);
    });
    on<RewardAddRemoveFavouriteLoad>((event, emit) async {
      await _mapRewardAddRemoveFavouriteLoadEventToState(event, emit);
    });
    on<RewardFavouriteLoad>((event, emit) async {
      await _mapRewardFavouriteLoadEventToState(event, emit);
    });
    on<RewardOutletLocationEnable>((event, emit) async {
      bool serviceEnabled;
      PermissionStatus permissionGranted;

      Storage().lastUpdateLoc = dateNow;

      serviceEnabled = await _location!.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location!.requestService();
        if (!serviceEnabled) {
          currentLatitude = Storage().latitude;
          currentLongitude = Storage().longitude;

          emit(RewardOutletStarted());
          return;
        }
      }

      permissionGranted = await _location!.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await _location!.requestPermission();

        if (permissionGranted == PermissionStatus.granted) {
          Location.instance.changeSettings(accuracy: (LocationAccuracy.high));

          if (Storage().latitude!.isNotEmpty &&
              Storage().longitude!.isNotEmpty) {
            currentLatitude = Storage().latitude;
            currentLongitude = Storage().longitude;
          } else {
            _currentLoc = await _getCurrentLocation();
            if (_currentLoc != null) {
              currentLatitude = _currentLoc!.latitude.toString();
              currentLongitude = _currentLoc!.longitude.toString();
            }
          }

          // if (Storage().code.isEmpty) {
          add(RewardDetailsLoad(rewardId: Storage().rewardId));
          // } else {
          //   add(RewardDetailsDynamicLoad(code: Storage().code));
          // }

          return;
        }

        if (permissionGranted == PermissionStatus.denied ||
            permissionGranted == PermissionStatus.deniedForever ||
            permissionGranted == PermissionStatus.grantedLimited) {
          if (accuracy == geoloc.LocationAccuracyStatus.reduced ||
              permissionGranted == PermissionStatus.grantedLimited) {
            if (Storage().latitude!.isNotEmpty &&
                Storage().longitude!.isNotEmpty) {
              currentLatitude = Storage().latitude;
              currentLongitude = Storage().longitude;
            } else {
              _currentLoc = await _getCurrentLocation();
              if (_currentLoc != null) {
                currentLatitude = _currentLoc!.latitude.toString();
                currentLongitude = _currentLoc!.longitude.toString();
              }
            }

            // if (Storage().code.isEmpty) {
            add(RewardDetailsLoad(rewardId: Storage().rewardId));
            // } else {
            //   add(RewardDetailsDynamicLoad(code: Storage().code));
            // }
            return;
          }
        }

        if (permissionGranted != PermissionStatus.granted) {
          if (Platform.isAndroid) {
            emit(RewardOutletLocationDisabled());
          } else {
            currentLatitude = Storage().latitude;
            currentLongitude = Storage().longitude;

            emit(RewardOutletStarted());
          }
          return;
        }
      }
      add(RewardOutletCheck());
    });
    on<RewardOutletLocationDisable>((event, emit) {
      currentLatitude = Storage().latitude;
      currentLongitude = Storage().longitude;

      emit(RewardOutletStarted());
      // emit(RewardOutletLocationDisabled());
    });
  }

  Future<bool> checkInternet() async {
    var connectionResult = await Connectivity().checkConnectivity();

    return connectionResult.contains(ConnectivityResult.none);
  }

  // Function to check location enable
  Future<void> _mapOutletCheckEventToState(
    RewardOutletCheck event,
    Emitter<RewardState> emit,
  ) async {
    emit(RewardLoading());

    bool serviceEnabled = await _isLocationServiceEnabled();

    if (!serviceEnabled) {
      if (Storage().locPermission == 'disable') {
        currentLatitude = Storage().latitude;
        currentLongitude = Storage().longitude;

        emit(RewardOutletStarted());
      } else {
        if (Storage().lastUpdateLoc.isEmpty &&
            Storage().lastUpdateLoc != dateNow) {
          emit(RewardOutletLocationRequested());
        } else {
          currentLatitude = Storage().latitude;
          currentLongitude = Storage().longitude;

          emit(RewardOutletStarted());
        }
      }
      // emit(RewardOutletLocationRequested());
    } else {
      await initialize();
      emit(RewardOutletStarted());
    }
  }

  // Function to check reward/purchase voucher list
  Future<void> _mapRewardReloadEventToState(
    RewardReload event,
    Emitter<RewardState> emit,
  ) async {
    emit(RewardRefresh());
  }

  // Function to check reward/purchase voucher list
  Future<void> _mapRewardScannerLoadEventToState(
    RewardScannerLoad event,
    Emitter<RewardState> emit,
  ) async {
    emit(RewardRefresh());
  }

  // Function to check reward/purchase voucher list
  Future<void> _mapRewardMerchantLoadEventToState(
    RewardMerchantLoad event,
    Emitter<RewardState> emit,
  ) async {
    if (Storage().rewardReload != 'no') {
      emit(RewardLoading());
    }

    var internet = await checkInternet();

    if (!internet) {
      try {
        var rewardMerchantGetResults = await _rewardMerchantGetUseCase.execute(
          RewardMerchantGetParams(
            merchantId: event.merchantId.toString(),
            token: Storage().token,
          ),
        );

        var rewards = rewardMerchantGetResults.rewards;

        // if no value or empty, will set the state as BulletinEmpty
        if (rewards.isEmpty) {
          emit(RewardEmpty());
          // else the state will be BulletinListLoaded
        } else {
          emit(RewardMerchantLoaded(rewards: rewards));
        }
      } catch (e) {
        if (e is InvalidSessionException) {
          emit(RewardSessionError(error: e.message));
        } else if (e is InvalidStatusException) {
          emit(RewardError(error: e.message));
        } else {
          emit(RewardError(error: e.toString()));
        }
      }
    } else {
      emit(RewardNetworkError(error: 'No internet Connection.'));
    }
  }

  // Function to check reward/purchase voucher list
  Future<void> _mapFilterCategoryLoadEventToState(
    FilterCategoryLoad event,
    Emitter<RewardState> emit,
  ) async {
    // if (Storage().rewardReload != 'no') {
    emit(RewardLoading());
    // }

    var internet = await checkInternet();

    if (!internet) {
      try {
        var filterCategoryGetResults = await _filterCategoryGetUseCase.execute(
          FilterCategoryGetParams(token: Storage().token),
        );

        var filterCategory = filterCategoryGetResults.filterData;

        // ignore: unnecessary_null_comparison
        if (filterCategory == null) {
          emit(RewardEmpty());
        } else {
          // ignore: unnecessary_type_check
          if (filterCategory is FilterData) {
            emit(FilterCategoryLoaded(filterData: filterCategory));
          } else {
            // if (filterCategory['isMaintenance'] == true) {
            //   emit(RewardMaintenanceError(message: filterCategory['message']));
            // } else {
            //   RewardError(error: rewards['message']);
            // }
          }
        }
      } catch (e) {
        if (e is InvalidSessionException) {
          emit(RewardSessionError(error: e.message));
        } else if (e is InvalidStatusException) {
          emit(RewardError(error: e.message));
        } else {
          emit(RewardError(error: e.toString()));
        }
      }
    } else {
      emit(RewardNetworkError(error: 'No internet Connection.'));
    }
  }

  // Function to check reward/purchase voucher list
  Future<void> _mapRewardListLoadEventToState(
    RewardListLoad event,
    Emitter<RewardState> emit,
  ) async {
    final requestedPage = rewardPage;
    if (isRewardFetching == false) {
      // emit(RewardLoading());
      // if (Storage().rewardReload != 'no') {
      //   emit(RewardLoading());
      // }
    } else {
      emit(RewardNextLoading());
    }

    var internet = await checkInternet();

    if (!internet) {
      try {
        var rewardListGetResults = await _rewardListGetUseCase.execute(
          RewardListGetParams(
            filterBy: event.filterBy,
            filterValue: event.filterValue,
            offset: requestedPage,
            token: Storage().token,
          ),
        );

        var rewards = rewardListGetResults.rewards;

        if (rewards is RewardData) {
          if (rewards.vouchers == null || rewards.vouchers!.isEmpty) {
            if (requestedPage == 0) {
              emit(RewardEmpty());
            } else {
              emit(RewardListStop());
            }
          } else {
            final nextPage = int.tryParse(
              Uri.tryParse(rewards.next ?? '')?.queryParameters['offset'] ?? '',
            );
            rewardPage = nextPage ?? requestedPage;
            emit(
              RewardListLoaded(
                voucherRewards: rewards,
                hasMore: nextPage != null && nextPage > requestedPage,
              ),
            );
          }
        } else {
          emit(RewardMaintenanceError(message: rewards['message']));
        }
      } catch (e) {
        if (e is InvalidSessionException) {
          emit(RewardSessionError(error: e.message));
        } else if (e is InvalidStatusException) {
          emit(RewardError(error: e.message));
        } else {
          emit(RewardError(error: e.toString()));
        }
      }
    } else {
      emit(RewardNetworkError(error: 'No internet Connection.'));
    }
  }

  // Function to get reward details
  Future<void> _mapRewardDetailsLoadEventToState(
    RewardDetailsLoad event,
    Emitter<RewardState> emit,
  ) async {
    if (Storage().rewardReload != 'no') {
      emit(RewardDetailsLoading());
    }

    var internet = await checkInternet();

    if (!internet) {
      try {
        var rewardDetailsGetResults = await _rewardDetailsGetUseCase.execute(
          RewardDetailsGetParams(
            token: Storage().token,
            rewardId: event.rewardId,
            latitude: currentLatitude!,
            longitude: currentLongitude!,
          ),
        );

        var details = rewardDetailsGetResults.details;

        if (details != null) {
          if (details is DetailsData) {
            emit(RewardDetailsLoaded(details: details));
          } else {
            if (details['isMaintenance'] == true) {
              emit(RewardMaintenanceError(message: details['message']));
            } else {
              RewardError(error: details['message']);
            }
          }
        }
      } catch (e) {
        if (e is InvalidSessionException) {
          emit(RewardSessionError(error: e.message));
        } else if (e is InvalidStatusException) {
          emit(RewardError(error: e.message));
        } else {
          emit(RewardError(error: e.toString()));
        }
      }
    } else {
      emit(RewardNetworkError(error: 'No internet Connection.'));
    }
  }

  // Function to get reward details with dynamic link code
  Future<void> _mapRewardDetailsDynamicLoadEventToState(
    RewardDetailsDynamicLoad event,
    Emitter<RewardState> emit,
  ) async {
    emit(RewardDetailsLoading());

    var internet = await checkInternet();

    if (!internet) {
      try {
        var rewardDetailsDynamicGetResults =
            await _rewardDetailsDynamicGetUseCase.execute(
              RewardDetailsDynamicGetParams(
                token: Storage().token,
                code: event.code,
                latitude: currentLatitude!,
                longitude: currentLongitude!,
              ),
            );

        var details = rewardDetailsDynamicGetResults.details;

        if (details == null) {
          emit(RewardDetailsEmpty());
        } else {
          if (details is DetailsData) {
            emit(RewardDetailsDynamicLoaded(details: details));
          } else {
            if (details['isMaintenance'] == true) {
              emit(RewardMaintenanceError(message: details['message']));
            } else {
              RewardError(error: details['message']);
            }
          }
        }
      } catch (e) {
        if (e is InvalidSessionException) {
          emit(RewardSessionError(error: e.message));
        } else if (e is InvalidStatusException) {
          emit(RewardError(error: e.message));
        } else {
          emit(RewardError(error: e.toString()));
        }
      }
    } else {
      emit(RewardNetworkError(error: 'No internet Connection.'));
    }
  }

  // Function to purchase reward/voucher
  Future<void> _mapRewardDownloadEventToState(
    RewardDownload event,
    Emitter<RewardState> emit,
  ) async {
    var internet = await checkInternet();

    if (!internet) {
      try {
        var rewardDownloadGetResults = await _rewardDownloadGetUseCase.execute(
          RewardDownloadGetParams(
            voucherId: event.voucherId,
            pin: event.pin,
            referral: event.referral,
            quantity: event.quantity,
            token: Storage().token,
          ),
        );

        var downloadResponse = rewardDownloadGetResults.success;

        if (downloadResponse['isMaintenance'] == false) {
          if (downloadResponse['status'] == true) {
            emit(RewardDownloadSuccess(data: downloadResponse));
          } else {
            emit(RewardRedeemFailed(redeemResponse: downloadResponse));
          }
          // if (success['status'] == false) {
          //   RewardError(error: success['message']);
          // } else {
          //   emit(RewardPurchaseSuccess(data: success));
          // }
        } else {
          emit(RewardMaintenanceError(message: downloadResponse['message']));
        }
      } catch (e) {
        if (e is InvalidSessionException) {
          emit(RewardSessionError(error: e.message));
        } else if (e is InvalidStatusException) {
          emit(RewardError(error: e.message));
        } else {
          emit(RewardError(error: e.toString()));
        }
      }
    } else {
      emit(RewardNetworkError(error: 'No internet Connection.'));
    }
  }

  // Function to purchase reward/voucher
  Future<void> _mapRewardPurchaseLoadEventToState(
    RewardPurchaseLoad event,
    Emitter<RewardState> emit,
  ) async {
    var internet = await checkInternet();

    if (!internet) {
      try {
        var rewardPurchaseGetResults = await _rewardPurchaseGetUseCase.execute(
          RewardPurchaseGetParams(
            voucherId: event.voucherId,
            redeemVia: event.redeemVia,
            pin: event.pin,
            points: event.points,
            referral: event.referral,
            quantity: event.quantity,
            token: Storage().token,
          ),
        );

        var purchaseResponse = rewardPurchaseGetResults.success;

        if (purchaseResponse['isMaintenance'] == false) {
          if (purchaseResponse['status'] == true) {
            emit(RewardPurchaseSuccess(data: purchaseResponse));
          } else {
            emit(RewardRedeemFailed(redeemResponse: purchaseResponse));
          }
        } else {
          emit(RewardMaintenanceError(message: purchaseResponse['message']));
        }
      } catch (e) {
        if (e is InvalidSessionException) {
          emit(RewardSessionError(error: e.message));
        } else if (e is InvalidStatusException) {
          emit(RewardError(error: e.message));
        } else {
          emit(RewardError(error: e.toString()));
        }
      }
    } else {
      emit(RewardNetworkError(error: 'No internet Connection.'));
    }
  }

  // Function to get outlet details
  Future<void> _mapRewardOutletDetailsLoadEventToState(
    RewardOutletDetailsLoad event,
    Emitter<RewardState> emit,
  ) async {
    if (!isReload) {
      emit(RewardOutletDetailsLoading());
    }

    var internet = await checkInternet();

    if (!internet) {
      try {
        var outletDetailsGetResults = await _outletDetailsGetUseCase.execute(
          OutletDetailsGetParams(
            outletId: event.outletId.toString(),
            token: Storage().token,
          ),
        );

        var details = outletDetailsGetResults.details;

        if (details == null) {
          emit(RewardOutletDetailsEmpty());
        } else {
          emit(RewardOutletDetailsLoaded(details: details));
        }
      } catch (e) {
        if (e is InvalidSessionException) {
          emit(RewardSessionError(error: e.message));
        } else if (e is InvalidStatusException) {
          emit(RewardError(error: e.message));
        } else {
          emit(RewardError(error: e.toString()));
        }
      }
    } else {
      emit(RewardNetworkError(error: 'No internet Connection.'));
    }
  }

  // Function to redeem reward by QR code
  Future<void> _mapRewardRedeemQrLoadEventToState(
    RewardRedeemQrLoad event,
    Emitter<RewardState> emit,
  ) async {
    // Guard against duplicate execution in BLoC
    if (isRedeemingQr) return;
    isRedeemingQr = true;

    try {
      var internet = await checkInternet();

      if (!internet) {
        var rewardRedeemQrGetResults = await _rewardRedeemQrGetUseCase.execute(
          RewardRedeemQrGetParams(code: event.code, token: Storage().token),
        );

        var redeemResponse = rewardRedeemQrGetResults.redeemResponse;

        // print('CALLLLLL RESPONSE BLOC: ${redeemResponse}');

        if (redeemResponse['isMaintenance'] == false) {
          if (redeemResponse['status'] == true) {
            emit(RewardRedeemSuccess(redeemResponse: redeemResponse));
          } else {
            emit(RewardRedeemFailed(redeemResponse: redeemResponse));
          }
        } else {
          emit(RewardMaintenanceError(message: redeemResponse['message']));
        }
      } else {
        emit(RewardNetworkError(error: 'No internet Connection.'));
      }
    } catch (e) {
      if (e is InvalidSessionException) {
        emit(RewardSessionError(error: e.message));
      } else if (e is InvalidStatusException) {
        emit(RewardError(error: e.message));
      } else {
        emit(RewardError(error: e.toString()));
      }
    } finally {
      // Reset flag once state emission finishes
      isRedeemingQr = false;
    }
  }

  //  Function to add/ remove favourite rewards
  Future<void> _mapRewardAddRemoveFavouriteLoadEventToState(
    RewardAddRemoveFavouriteLoad event,
    Emitter<RewardState> emit,
  ) async {
    var internet = await checkInternet();

    if (!internet) {
      try {
        // emit(ProfileUpdating());
        var addRemoveFavourite = await rewardRepository!.addRemoveFavourite(
          token: Storage().token,
          voucherId: event.voucherId,
        );

        if (!addRemoveFavourite['isMaintenance']) {
          if (addRemoveFavourite['status'] == true) {
            // print('ADDREMOVE: ${addRemoveFavourite['data']}');
            if (Storage().page == 'details_wishlist') {
              Storage().rewardReload = 'no';

              add(RewardDetailsLoad(rewardId: Storage().rewardId));
            } else if (Storage().page == 'reward_wishlist') {
              rewardPage = 0;

              emit(
                RewardAddRemoveFavouriteLoaded(
                  isFavourite: addRemoveFavourite['data']['isFavourite'],
                  voucherId: event.voucherId,
                ),
              );
              // Storage().rewardReload = 'no';
              // emit(FavClick());
              // emit(
              //   RewardAddRemoveFavouriteLoaded(
              //     voucherId: event.voucherId,
              //     isFavourite: addRemoveFavourite['data']['isFavourite'],
              //   ),
              // );

              add(
                RewardListLoad(
                  filterBy: event.filterBy,
                  filterValue: event.filterValue,
                ),
              );
            } else if (Storage().page == 'merchant_wishlist') {
              Storage().rewardReload = 'no';
              // emit(FavClick());

              emit(
                RewardAddRemoveFavouriteLoaded(
                  isFavourite: addRemoveFavourite['data']['isFavourite'],
                  voucherId: event.voucherId,
                ),
              );
              add(RewardMerchantLoad(merchantId: Storage().merchantId));
            } else {
              add(RewardOutletCheck());
            }
          }
        } else {
          emit(RewardMaintenanceError(message: addRemoveFavourite['message']));
        }

        // add(ProfileLoad());
      } catch (e) {
        if (e is InvalidSessionException) {
          emit(RewardSessionError(error: e.message));
        } else if (e is InvalidStatusException) {
          emit(RewardError(error: e.message));
        } else {
          emit(RewardError(error: e.toString()));
        }
      }
    } else {
      emit(RewardNetworkError(error: 'No internet Connection.'));
    }
  }

  //  Function to get reward favourite
  Future<void> _mapRewardFavouriteLoadEventToState(
    RewardFavouriteLoad event,
    Emitter<RewardState> emit,
  ) async {
    var internet = await checkInternet();

    if (!internet) {
      try {
        var getFavourite = await rewardRepository!.getFavourite(
          token: Storage().token,
          latitude: currentLatitude!,
          longitude: currentLongitude!,
        );

        if (getFavourite != null) {
          emit(RewardFavouriteLoaded(rewardFavourite: getFavourite));
        } else {
          emit(RewardEmpty());
        }
      } catch (e) {
        if (e is InvalidSessionException) {
          emit(RewardSessionError(error: e.message));
        } else if (e is InvalidStatusException) {
          emit(RewardError(error: e.message));
        } else {
          emit(RewardError(error: e.toString()));
        }
      }
    } else {
      emit(RewardNetworkError(error: 'No internet Connection.'));
    }
  }

  Future<bool> _isLocationServiceEnabled() async {
    _location ??= Location();

    bool serviceEnabled = await _location!.serviceEnabled();
    PermissionStatus permissionGranted = await _location!.hasPermission();

    await geoloc.Geolocator.getLocationAccuracy()
        .then((value) {
          if (value == geoloc.LocationAccuracyStatus.reduced) {
            accuracy = geoloc.LocationAccuracyStatus.reduced;
          }
        })
        .catchError((e) {});

    if (permissionGranted == PermissionStatus.denied ||
        permissionGranted == PermissionStatus.deniedForever) {
      if (accuracy == geoloc.LocationAccuracyStatus.reduced) {
        return serviceEnabled &&
            accuracy == geoloc.LocationAccuracyStatus.reduced;
      }
    }

    if (Platform.isIOS &&
        permissionGranted == PermissionStatus.grantedLimited) {
      return (serviceEnabled &&
          permissionGranted == PermissionStatus.grantedLimited);
    }

    return (serviceEnabled && permissionGranted == PermissionStatus.granted);
  }

  Future<geoloc.Position?> _getCurrentLocation() async {
    geoloc.Position? currentPosition;

    final geoloc.LocationSettings locationSettings = geoloc.LocationSettings(
      accuracy: geoloc.LocationAccuracy.best,
      distanceFilter: 100,
      timeLimit: Duration(seconds: 5),
    );

    try {
      currentPosition = await geoloc.Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );
    } catch (e) {
      e;
    }

    return currentPosition;
  }
}
