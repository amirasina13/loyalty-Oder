import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:geolocator/geolocator.dart' as geoloc;
import 'package:intl/intl.dart';
import 'package:location/location.dart';

import '../../../app_setting/app_setting.dart';
import '../../../data/data.dart';
import '../../../domain/domain.dart';
import '../../../locator.dart';
import 'voucher.dart';

class VoucherBloc extends Bloc<VoucherEvent, VoucherState> {
  // final VoucherTransactionsGetUseCase _voucherTransactionsGetUseCase;
  final VoucherCategoriesGetUseCase _voucherCategoriesGetUseCase;
  final VoucherPastTransactionsGetUseCase _voucherPastTransactionsGetUseCase;
  final VoucherDetailsGetUseCase _voucherDetailsGetUseCase;
  final VoucherPastDetailsGetUseCase _voucherPastDetailsGetUseCase;
  final RedeemVoucherGetUseCase _redeemVoucherGetUseCase;
  final RatingVoucherGetUseCase _ratingVoucherGetUseCase;
  // final ProfileBloc profileBloc;

  Location? _location;
  geoloc.Position? _currentLoc;
  String? currentLatitude, currentLongitude;
  var now = DateTime.now();
  var format = DateFormat('yyyy-MM-dd');
  late String dateNow = format.format(now);
  geoloc.LocationAccuracyStatus? accuracy;
  bool reloadBack = false;

  initialize() async {
    _location ??= Location();

    // region fail-safe
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

  VoucherBloc()
    : _voucherCategoriesGetUseCase = sl(),
      _voucherPastTransactionsGetUseCase = sl(),
      _voucherDetailsGetUseCase = sl(),
      _voucherPastDetailsGetUseCase = sl(),
      _redeemVoucherGetUseCase = sl(),
      _ratingVoucherGetUseCase = sl(),
      super(VoucherInitial()) {
    on<VoucherOutletCheck>((event, emit) async {
      if (state is VoucherOutletStarted) {
        await _mapOutletCheckEventToState(event, emit);
      } else {
        await _mapOutletCheckEventToState(event, emit);
      }
    });
    // on<VoucherTransactionsLoad>((event, emit) async {
    //   await _mapVoucherTransactionsLoadEventToState(event, emit);
    // });
    on<VoucherCategoriesLoad>((event, emit) async {
      await _mapVoucherMerchantLoadEventToState(event, emit);
    });
    on<VoucherCategoryCount>((event, emit) async {
      await _mapVoucherCategoryCountEventToState(event, emit);
    });
    on<VoucherPastTransactionsLoad>((event, emit) async {
      await _mapVoucherPastTransactionsLoadEventToState(event, emit);
    });
    on<VoucherDetailsLoad>((event, emit) async {
      await _mapVoucherDetailsLoadEventToState(event, emit);
    });
    on<VoucherPastDetailsLoad>((event, emit) async {
      await _mapVoucherPastDetailsLoadEventToState(event, emit);
    });
    on<VoucherRedeem>((event, emit) async {
      await _mapVoucherRedeemEventToState(event, emit);
    });
    on<VoucherRating>((event, emit) async {
      await _mapVoucherRatingEventToState(event, emit);
    });
    on<VoucherOutletLocationEnable>((event, emit) async {
      bool serviceEnabled;
      PermissionStatus permissionGranted;

      serviceEnabled = await _location!.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location!.requestService();
        if (!serviceEnabled) {
          currentLatitude = Storage().latitude;
          currentLongitude = Storage().longitude;

          emit(VoucherOutletStarted());
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

          add(VoucherDetailsLoad(voucherId: Storage().voucherId));
          return;
        }

        if (permissionGranted == PermissionStatus.denied ||
            permissionGranted == PermissionStatus.deniedForever ||
            permissionGranted == PermissionStatus.grantedLimited) {
          if (accuracy == geoloc.LocationAccuracyStatus.reduced) {
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

            add(VoucherDetailsLoad(voucherId: Storage().voucherId));
            return;
          }
        }

        if (permissionGranted != PermissionStatus.granted) {
          if (Platform.isAndroid) {
            emit(VoucherOutletLocationDisabled());
          } else {
            currentLatitude = Storage().latitude;
            currentLongitude = Storage().longitude;

            emit(VoucherOutletStarted());
          }
          return;
        }
      }
      add(VoucherOutletCheck());
    });
    on<VoucherOutletLocationDisable>((event, emit) {
      currentLatitude = Storage().latitude;
      currentLongitude = Storage().longitude;

      emit(VoucherOutletStarted());
      // emit(VoucherOutletLocationDisabled());
    });
  }

  Future<bool> checkInternet() async {
    var connectionResult = await Connectivity().checkConnectivity();

    return connectionResult.contains(ConnectivityResult.none);
  }

  // Function to check location enable
  Future<void> _mapOutletCheckEventToState(
    VoucherOutletCheck event,
    Emitter<VoucherState> emit,
  ) async {
    emit(VoucherLoading());

    bool serviceEnabled = await _isLocationServiceEnabled();

    if (!serviceEnabled) {
      if (Storage().locPermission == 'disable') {
        currentLatitude = Storage().latitude;
        currentLongitude = Storage().longitude;

        emit(VoucherOutletStarted());
      } else {
        if (Storage().lastUpdateLoc.isEmpty &&
            Storage().lastUpdateLoc != dateNow) {
          emit(VoucherOutletLocationRequested());
        } else {
          currentLatitude = Storage().latitude;
          currentLongitude = Storage().longitude;

          emit(VoucherOutletStarted());
        }
      }
    } else {
      await initialize();
      emit(VoucherOutletStarted());
    }
  }

  // Function to get lis of my voucher (current)
  Future<void> _mapVoucherMerchantLoadEventToState(
    VoucherCategoriesLoad event,
    Emitter<VoucherState> emit,
  ) async {
    emit(VoucherLoading());

    var internet = await checkInternet();

    if (!internet) {
      try {
        var voucherCategoriesGetResults = await _voucherCategoriesGetUseCase
            .execute(
              VoucherCategoriesGetParams(
                filterBy: event.filterBy,
                filterValue: event.filterValue,
                token: Storage().token,
              ),
            );

        var vouchers = voucherCategoriesGetResults.vouchers;

        if (vouchers == null) {
          emit(VoucherEmpty());
        } else {
          if (vouchers is VoucherData) {
            emit(VoucherCategoriesLoaded(vouchers: vouchers));
          } else {
            if (vouchers['isMaintenance'] == true) {
              emit(VoucherMaintenanceError(message: vouchers['message']));
            } else {
              emit(VoucherError(error: vouchers['message']));
            }
          }
        }
      } catch (e) {
        if (e is InvalidSessionException) {
          emit(VoucherSessionError(error: e.message));
        } else if (e is InvalidStatusException) {
          emit(VoucherError(error: e.message));
        } else {
          emit(VoucherError(error: e.toString()));
        }
      }
    } else {
      emit(VoucherNetworkError(error: 'No internet Connection.'));
    }
  }

  // Function to get lis of my voucher (current)
  Future<void> _mapVoucherCategoryCountEventToState(
    VoucherCategoryCount event,
    Emitter<VoucherState> emit,
  ) async {
    emit(VoucherLoading());

    var internet = await checkInternet();

    if (!internet) {
      try {
        var voucherCategoriesGetResults = await _voucherCategoriesGetUseCase
            .execute(
              VoucherCategoriesGetParams(
                filterBy: 'all',
                filterValue: 'all',
                token: Storage().token,
              ),
            );

        var vouchers = voucherCategoriesGetResults.vouchers;

        if (vouchers == null) {
          emit(VoucherEmpty());
        } else {
          if (vouchers is VoucherData) {
            if (vouchers.vouchers != null && vouchers.vouchers!.isNotEmpty) {
              emit(
                VoucherCountLoaded(vouchersLength: vouchers.vouchers!.length),
              );
            } else {
              VoucherCountLoaded(vouchersLength: 0);
            }
          } else {
            if (vouchers['isMaintenance'] == true) {
              emit(VoucherMaintenanceError(message: vouchers['message']));
            } else {
              emit(VoucherError(error: vouchers['message']));
            }
          }
        }
      } catch (e) {
        if (e is InvalidSessionException) {
          emit(VoucherSessionError(error: e.message));
        } else if (e is InvalidStatusException) {
          emit(VoucherError(error: e.message));
        } else {
          emit(VoucherError(error: e.toString()));
        }
      }
    } else {
      emit(VoucherNetworkError(error: 'No internet Connection.'));
    }
  }

  // Function to get list of my voucher (past)
  Future<void> _mapVoucherPastTransactionsLoadEventToState(
    VoucherPastTransactionsLoad event,
    Emitter<VoucherState> emit,
  ) async {
    emit(VoucherLoading());

    var internet = await checkInternet();

    if (!internet) {
      try {
        var voucherPastTransactionsGetResults =
            await _voucherPastTransactionsGetUseCase.execute(
              VoucherPastTransactionsGetParams(token: Storage().token),
            );

        var vouchers = voucherPastTransactionsGetResults.vouchers;

        if (vouchers == null) {
          emit(VoucherEmpty());
        } else {
          if (vouchers is List<VoucherPast>) {
            emit(VoucherPastTransactionsLoaded(vouchersPast: vouchers));
          } else {
            if (vouchers['isMaintenance'] == true) {
              emit(VoucherMaintenanceError(message: vouchers['message']));
            } else {
              VoucherError(error: vouchers['message']);
            }
          }
        }
      } catch (e) {
        if (e is InvalidSessionException) {
          emit(VoucherSessionError(error: e.message));
        } else if (e is InvalidStatusException) {
          emit(VoucherError(error: e.message));
        } else {
          emit(VoucherError(error: e.toString()));
        }
      }
    } else {
      emit(VoucherNetworkError(error: 'No internet Connection.'));
    }
  }

  // Function to get details of my voucher
  Future<void> _mapVoucherDetailsLoadEventToState(
    VoucherDetailsLoad event,
    Emitter<VoucherState> emit,
  ) async {
    if (reloadBack == false) {
      emit(VoucherDetailsLoading());
    } else {
      emit(VoucherReload());
    }

    var internet = await checkInternet();

    if (!internet) {
      try {
        var voucherDetailsGetResults = await _voucherDetailsGetUseCase.execute(
          VoucherDetailsGetParams(
            token: Storage().token,
            voucherId: event.voucherId,
            latitude: currentLatitude!, //location.latitude.toString(),
            longitude: currentLongitude!,
          ),
        );

        var details = voucherDetailsGetResults.details;

        if (details == null) {
          emit(VoucherDetailsEmpty());
        } else {
          if (details is VoucherDetails) {
            emit(VoucherDetailsLoaded(details: details));
          } else {
            if (details['isMaintenance'] == true) {
              emit(VoucherMaintenanceError(message: details['message']));
            } else {
              VoucherError(error: details['message']);
            }
          }
        }
      } catch (e) {
        if (e is InvalidSessionException) {
          emit(VoucherSessionError(error: e.message));
        } else if (e is InvalidStatusException) {
          emit(VoucherError(error: e.message));
        } else {
          emit(VoucherError(error: e.toString()));
        }
      }
    } else {
      emit(VoucherNetworkError(error: 'No internet Connection.'));
    }
  }

  // Function to get details of my voucher past/history
  Future<void> _mapVoucherPastDetailsLoadEventToState(
    VoucherPastDetailsLoad event,
    Emitter<VoucherState> emit,
  ) async {
    if (reloadBack == false) {
      emit(VoucherPastDetailsLoading());
    } else {
      emit(VoucherReload());
    }

    var internet = await checkInternet();

    if (!internet) {
      try {
        var voucherPastDetailsGetResults = await _voucherPastDetailsGetUseCase
            .execute(
              VoucherPastDetailsGetParams(
                token: Storage().token,
                voucherId: event.voucherId,
              ),
            );

        var pastDetails = voucherPastDetailsGetResults.pastDetails;

        if (pastDetails == null) {
          emit(VoucherDetailsEmpty());
        } else {
          if (pastDetails is VoucherPastDetails) {
            emit(VoucherPastDetailsLoaded(pastDetails: pastDetails));
          } else {
            if (pastDetails['isMaintenance'] == true) {
              emit(VoucherMaintenanceError(message: pastDetails['message']));
            } else {
              VoucherError(error: pastDetails['message']);
            }
          }
        }
      } catch (e) {
        if (e is InvalidSessionException) {
          emit(VoucherSessionError(error: e.message));
        } else if (e is InvalidStatusException) {
          emit(VoucherError(error: e.message));
        } else {
          emit(VoucherError(error: e.toString()));
        }
      }
    } else {
      emit(VoucherNetworkError(error: 'No internet Connection.'));
    }
  }

  // Function to redeem voucher by slide/qr
  Future<void> _mapVoucherRedeemEventToState(
    VoucherRedeem event,
    Emitter<VoucherState> emit,
  ) async {
    var internet = await checkInternet();

    if (!internet) {
      try {
        var redeemVoucherGetResults = await _redeemVoucherGetUseCase.execute(
          RedeemVoucherGetParams(
            voucherId: event.voucherId,
            qrCode: event.qrCode,
            pin: event.pin,
            token: Storage().token,
          ),
        );

        var redeemResponse = redeemVoucherGetResults.redeemResponse;

        if (redeemResponse['isMaintenance'] == false) {
          if (redeemResponse['status'] == true) {
            emit(VoucherRedeemSuccess(redeemResponse: redeemResponse));
          } else {
            emit(VoucherRedeemFailed(redeemResponse: redeemResponse));
          }
        } else {
          emit(VoucherMaintenanceError(message: redeemResponse['message']));
        }
      } catch (e) {
        if (e is InvalidSessionException) {
          emit(VoucherSessionError(error: e.message));
        } else if (e is InvalidStatusException) {
          emit(VoucherError(error: e.message));
        } else {
          emit(VoucherError(error: e.toString()));
        }
      }
    } else {
      emit(VoucherNetworkError(error: 'No internet Connection.'));
    }
  }

  // Function to rating voucher
  Future<void> _mapVoucherRatingEventToState(
    VoucherRating event,
    Emitter<VoucherState> emit,
  ) async {
    var internet = await checkInternet();

    if (!internet) {
      try {
        var ratingVoucherGetResults = await _ratingVoucherGetUseCase.execute(
          RatingVoucherGetParams(
            id: event.id,
            rating: event.rating,
            comment: event.comment,
            token: Storage().token,
          ),
        );

        var ratingResponse = ratingVoucherGetResults.ratingResponse;

        if (ratingResponse['isMaintenance'] == false) {
          if (ratingResponse['status'] == true) {
            emit(VoucherRatingSuccess(ratingResponse: ratingResponse));
          } else {
            emit(VoucherRatingFailed(ratingResponse: ratingResponse));
          }
        } else {
          emit(VoucherMaintenanceError(message: ratingResponse['message']));
        }
      } catch (e) {
        if (e is InvalidSessionException) {
          emit(VoucherSessionError(error: e.message));
        } else if (e is InvalidStatusException) {
          emit(VoucherError(error: e.message));
        } else {
          emit(VoucherError(error: e.toString()));
        }
      }
    } else {
      emit(VoucherNetworkError(error: 'No internet Connection.'));
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
