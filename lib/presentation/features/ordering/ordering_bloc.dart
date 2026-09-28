import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geolocator/geolocator.dart' as geoloc;
import 'package:intl/intl.dart';
import 'package:location/location.dart';

import '../../../app_setting/app_setting.dart';
import '../../../data/data.dart';
import '../../../domain/domain.dart';
import '../../../locator.dart';
import 'ordering.dart';

class OrderingBloc extends Bloc<OrderingEvent, OrderingState> {
  final NearbyOutletGetUseCase _nearbyOutletGetUseCase;
  final BrandsListGetUseCase _brandsListGetUseCase;
  final OutletListGetUseCase _outletListGetUseCase;
  OrderingRepository? orderingRepository;

  Location? _location;
  // LocationData? _currentLocation;
  geoloc.Position? _currentLoc;
  String? currentLatitude,
      currentLongitude,
      saveCurrentLatitude,
      saveCurrentLongitude;
  String? fullAddress, address;
  var now = DateTime.now();
  var format = DateFormat('yyyy-MM-dd');
  late String dateNow = format.format(now);
  geoloc.LocationAccuracyStatus? accuracy;
  int nearbyPage = 0;
  bool isNearbyFetching = false;
  bool isFirstLoad = true;
  List<NearbyOutletList> outlets = [];
  bool isReload = false;

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
          // print('VALUE ACCURACY ORDER: $value');
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

  OrderingBloc({required this.orderingRepository})
    : _nearbyOutletGetUseCase = sl(),
      _brandsListGetUseCase = sl(),
      _outletListGetUseCase = sl(),
      super(OrderingInitial()) {
    // on<BrandsCheckingLoad>((event, emit) async {
    //   await _mapBrandsCheckingLoadEventToState(event, emit);
    // });
    // on<BrandsLoad>((event, emit) async {
    //   await _mapBrandsLoadEventToState(event, emit);
    // });

    on<OrderingCheck>((event, emit) async {
      if (state is OrderingStarted) {
        await _mapOrderingCheckEventToState(event, emit);
      } else {
        await _mapOrderingCheckEventToState(event, emit);
      }
    });
    on<NearbyLoad>((event, emit) async {
      await _mapNearbyOutletLoadEventToState(event, emit);
    });
    on<BrandsLoad>((event, emit) async {
      await _mapBrandsLoadEventToState(event, emit);
    });
    on<OutletOrderLoad>((event, emit) async {
      await _mapOrderingOutletLoadEventToState(event, emit);
    });
    on<MerchantAddRemoveFavouriteLoad>((event, emit) async {
      await _mapMerchantAddRemoveFavouriteLoadEventToState(event, emit);
    });
    on<MerchantBookmarkLoad>((event, emit) async {
      await _mapMerchantBookmarkLoadEventToState(event, emit);
    });
    on<OutletAddRemoveFavouriteLoad>((event, emit) async {
      await _mapOutletAddRemoveFavouriteLoadEventToState(event, emit);
    });
    on<OutletFavListLoad>((event, emit) async {
      await _mapOutletFavListLoadEventToState(event, emit);
    });
    // on<OutletMerchantLoad>((event, emit) async {
    //   await _mapOutletMerchantLoadEventToState(event, emit);
    // });
    on<OrderingLocationEnable>((event, emit) async {
      bool serviceEnabled;
      PermissionStatus permissionGranted;

      serviceEnabled = await _location!.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location!.requestService();
        if (!serviceEnabled) {
          currentLatitude = Storage().latitude;
          currentLongitude = Storage().longitude;

          emit(OrderingStarted());
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

            return;
          }
        }

        if (permissionGranted != PermissionStatus.granted) {
          if (Platform.isAndroid) {
            emit(OrderingLocationDisabled());
          } else {
            currentLatitude = Storage().latitude;
            currentLongitude = Storage().longitude;

            emit(OrderingStarted());
          }
          return;
        }
      }
      add(OrderingCheck());
    });
    on<OrderingLocationDisable>((event, emit) async {
      currentLatitude = Storage().latitude;
      currentLongitude = Storage().longitude;

      emit(OrderingStarted());

      // emit(OrderingLocationDisabled());
    });
  }

  Future<bool> checkInternet() async {
    var connectionResult = await Connectivity().checkConnectivity();

    return connectionResult.contains(ConnectivityResult.none);
  }

  // Function to check location enable
  Future<void> _mapOrderingCheckEventToState(
    event,
    Emitter<OrderingState> emit,
  ) async {
    if (isReload == false) {
      emit(OrderingLoading());
    }

    bool serviceEnabled = await _isLocationServiceEnabled();

    if (!serviceEnabled) {
      if (Storage().locPermission == 'disable') {
        currentLatitude = Storage().latitude;
        currentLongitude = Storage().longitude;

        emit(OrderingStarted());
      } else {
        if (Storage().lastUpdateLoc.isEmpty &&
            Storage().lastUpdateLoc != dateNow) {
          emit(OrderingLocationRequested());
        } else {
          currentLatitude = Storage().latitude;
          currentLongitude = Storage().longitude;

          emit(OrderingStarted());
        }
      }
      // emit(OrderingLocationRequested());
    } else {
      await initialize();
      emit(OrderingStarted());
    }
  }

  // Function to get list of transaction history for points
  Future<void> _mapNearbyOutletLoadEventToState(
    NearbyLoad event,
    Emitter<OrderingState> emit,
  ) async {
    await initialize();

    if (isFirstLoad == true) {
      nearbyPage = 0;
    } else {
      nearbyPage = nearbyPage;
    }

    if (isNearbyFetching == false) {
      // print('NEARBY PAGE FALSE: $nearbyPage');
      emit(OrderingLoading());
    } else {
      // print('NEARBY PAGE TRUE: $nearbyPage');
      emit(NearbyNextLoading());
    }

    var internet = await checkInternet();

    if (!internet) {
      try {
        var nearbyOutletGetResults = await _nearbyOutletGetUseCase.execute(
          NearbyOutletGetParams(
            token: Storage().token,
            latitude: currentLatitude!,
            longitude: currentLongitude!,
            page: nearbyPage,
          ),
        );

        var outlets = nearbyOutletGetResults.outlets;

        // print('NEARBYBLOC: $outlets');

        if (outlets is NearbyOutlet) {
          if (outlets.outlets == null || outlets.outlets!.isEmpty) {
            if (nearbyPage == 0) {
              emit(NearbyEmpty());
            } else {
              emit(NearbyListStop());
            }
          } else {
            // page += AppSettings.limit;

            final startIndex = outlets.next!.indexOf('=');
            final endIndex = outlets.next!.indexOf(
              '&',
              startIndex + '='.length,
            );

            nearbyPage = int.parse(
              outlets.next!.substring(startIndex + '='.length, endIndex),
            );

            emit(NearbyLoaded(outlets: outlets));
          }
        } else {
          emit(OrderingMaintenanceError(message: outlets['message']));
        }
      } catch (e) {
        // print('NEARBYERROR: $e');
        if (e is InvalidSessionException) {
          emit(OrderingSessionError(error: e.message));
        } else if (e is InvalidStatusException) {
          emit(OrderingError(error: e.message));
        } else {
          emit(OrderingError(error: e.toString()));
        }
      }
    } else {
      emit(OrderingNetworkError(error: 'No internet Connection.'));
    }
  }

  // // Function to get list of transaction history for points
  // Future<void> _mapNearbySearchEventToState(
  //     NearbySearch event, Emitter<OrderingState> emit) async {
  //   emit(NearbySearchStop());
  // }

  // Function to get list outlet based on brands
  Future<void> _mapBrandsLoadEventToState(
    BrandsLoad event,
    Emitter<OrderingState> emit,
  ) async {
    if (event.loadingFirst == true) {
      emit(OrderingLoading());
    } else {
      emit(BrandsLoading());
    }

    var internet = await checkInternet();
    await initialize();

    if (!internet) {
      try {
        var brandsListGetResults = await _brandsListGetUseCase.execute(
          BrandsListGetParams(
            categoryId: event.categoryId,
            latitude: currentLatitude!,
            longitude: currentLongitude!,
            token: Storage().token,
          ),
        );

        var brandsList = brandsListGetResults.merchants;

        if (brandsList == null) {
          emit(OrderingEmpty());
        } else {
          if (brandsList is List<MerchantList>) {
            emit(BrandsLoaded(merchants: brandsList));
          } else {
            if (brandsList['isMaintenance'] == true) {
              emit(OrderingMaintenanceError(message: brandsList['message']));
            } else {
              OrderingError(error: brandsList['message']);
            }
          }
        }
      } catch (e) {
        if (e is InvalidSessionException) {
          emit(OrderingSessionError(error: e.message));
        } else if (e is InvalidStatusException) {
          emit(OrderingError(error: e.message));
        } else {
          emit(OrderingError(error: e.toString()));
        }
      }
    } else {
      emit(OrderingNetworkError(error: 'No internet Connection.'));
    }
  }

  // Function to get list outlet based on brands
  Future<void> _mapOrderingOutletLoadEventToState(
    OutletOrderLoad event,
    Emitter<OrderingState> emit,
  ) async {
    // emit(OrderingLoading());

    var internet = await checkInternet();

    // if (Storage().address!.isNotEmpty) {
    //   address = Storage().address;
    // } else {
    //   address = await getAddressFromLatLong(currentLatitude, currentLongitude);
    // }

    if (!internet) {
      try {
        var outletListGetResults = await _outletListGetUseCase.execute(
          OutletListGetParams(
            brandId: event.brandId,
            latitude: currentLatitude!,
            longitude: currentLongitude!,
            token: Storage().token,
          ),
        );

        var outletList = outletListGetResults.outlets;

        // print('OUTLIST INFO BLOC: $outletList');

        if (outletList == null) {
          emit(OrderingEmpty());
        } else {
          saveCurrentLatitude = currentLatitude;
          saveCurrentLongitude = currentLongitude;

          if (outletList is OutletInfo) {
            emit(OutletsLoaded(outlets: outletList));
          } else {
            if (outletList['isMaintenance'] == true) {
              emit(OrderingMaintenanceError(message: outletList['message']));
            } else {
              OrderingError(error: outletList['message']);
            }
          }
        }
      } catch (e) {
        if (e is InvalidSessionException) {
          emit(OrderingSessionError(error: e.message));
        } else if (e is InvalidStatusException) {
          emit(OrderingError(error: e.message));
        } else {
          emit(OrderingError(error: e.toString()));
        }
      }
    } else {
      emit(OrderingNetworkError(error: 'No internet Connection.'));
    }
  }

  //  Function to add/ remove favourite rewards
  Future<void> _mapMerchantAddRemoveFavouriteLoadEventToState(
    MerchantAddRemoveFavouriteLoad event,
    Emitter<OrderingState> emit,
  ) async {
    var internet = await checkInternet();

    if (!internet) {
      try {
        // emit(ProfileUpdating());
        var addRemoveFavourite = await orderingRepository!.addRemoveBookmark(
          token: Storage().token,
          merchantId: event.merchantId,
        );

        if (!addRemoveFavourite['isMaintenance']) {
          if (addRemoveFavourite['status'] == true) {
            if (Storage().page != 'wallet_bookmark') {
              Storage().rewardReload = 'no';

              add(OutletOrderLoad(brandId: event.merchantId));
            } else {
              isReload = true;
              add(OrderingCheck());
            }
          }
        } else {
          emit(
            OrderingMaintenanceError(message: addRemoveFavourite['message']),
          );
        }

        // add(ProfileLoad());
      } catch (e) {
        if (e is InvalidSessionException) {
          emit(OrderingSessionError(error: e.message));
        } else if (e is InvalidStatusException) {
          emit(OrderingError(error: e.message));
        } else {
          emit(OrderingError(error: e.toString()));
        }
      }
    } else {
      emit(OrderingNetworkError(error: 'No internet Connection.'));
    }
  }

  //  Function to get reward favourite
  Future<void> _mapMerchantBookmarkLoadEventToState(
    MerchantBookmarkLoad event,
    Emitter<OrderingState> emit,
  ) async {
    var internet = await checkInternet();

    if (isReload == false) {
      OrderingLoading();
    }

    if (!internet) {
      try {
        // emit(ProfileUpdating());
        var getBookmark = await orderingRepository!.getBookmark(
          token: Storage().token,
          latitude: currentLatitude!,
          longitude: currentLongitude!,
        );

        // print('GETFAVOURIE: $getBookmark');

        if (getBookmark != null) {
          emit(MerchantBookmarkLoaded(merchantBookmark: getBookmark));
        } else {
          emit(OrderingEmpty());
        }
      } catch (e) {
        if (e is InvalidSessionException) {
          emit(OrderingSessionError(error: e.message));
        } else if (e is InvalidStatusException) {
          emit(OrderingError(error: e.message));
        } else {
          emit(OrderingError(error: e.toString()));
        }
      }
    } else {
      emit(OrderingNetworkError(error: 'No internet Connection.'));
    }
  }

  //  Function to add/ remove favourite outlet
  Future<void> _mapOutletAddRemoveFavouriteLoadEventToState(
    OutletAddRemoveFavouriteLoad event,
    Emitter<OrderingState> emit,
  ) async {
    var internet = await checkInternet();

    if (!internet) {
      try {
        // emit(ProfileUpdating());
        var addRemoveFavourite = await orderingRepository!.addRemoveFavOutlet(
          token: Storage().token,
          outletId: event.outletId,
        );

        if (!addRemoveFavourite['isMaintenance']) {
          if (addRemoveFavourite['status'] == true) {
            if (Storage().page == 'outlet_details') {
              emit(FavouriteAddRemove(favOutlet: addRemoveFavourite));
            } else if (Storage().page == 'outletFav_merchant') {
              Storage().rewardReload = 'no';

              emit(
                OutletAddRemoveFavouriteLoaded(
                  isFavourite: addRemoveFavourite['data']['isFavourite'],
                  outletId: event.outletId,
                  merchantId: event.merchantId,
                ),
              );
              isReload = true;
              add(OrderingCheck());

              // add(OutletOrderLoad(brandId: int.parse(event.merchantId)));
            } else {
              isReload = true;
              add(OrderingCheck());
            }
          }
        } else {
          emit(
            OrderingMaintenanceError(message: addRemoveFavourite['message']),
          );
        }

        // add(ProfileLoad());
      } catch (e) {
        if (e is InvalidSessionException) {
          emit(OrderingSessionError(error: e.message));
        } else if (e is InvalidStatusException) {
          emit(OrderingError(error: e.message));
        } else {
          emit(OrderingError(error: e.toString()));
        }
      }
    } else {
      emit(OrderingNetworkError(error: 'No internet Connection.'));
    }
  }

  //  Function to get outlet favourite list
  Future<void> _mapOutletFavListLoadEventToState(
    OutletFavListLoad event,
    Emitter<OrderingState> emit,
  ) async {
    var internet = await checkInternet();

    if (isReload == false) {
      OrderingLoading();
    }

    if (!internet) {
      try {
        // emit(ProfileUpdating());
        var getOutletFav = await orderingRepository!.getFavOutlet(
          token: Storage().token,
          latitude: currentLatitude!,
          longitude: currentLongitude!,
        );

        if (getOutletFav != null) {
          emit(FavOutletListLoaded(outletListFav: getOutletFav));
        } else {
          emit(OrderingEmpty());
        }
      } catch (e) {
        if (e is InvalidSessionException) {
          emit(OrderingSessionError(error: e.message));
        } else if (e is InvalidStatusException) {
          emit(OrderingError(error: e.message));
        } else {
          emit(OrderingError(error: e.toString()));
        }
      }
    } else {
      emit(OrderingNetworkError(error: 'No internet Connection.'));
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
      currentPosition = await geoloc.Geolocator.getLastKnownPosition();
      e;
    }

    return currentPosition;
  }

  // Future getAddressFromLatLong(String? currentLat, String? currentLng) async {
  //   List<geocoding.Placemark> placemarks;

  //   double latitude = double.parse(currentLat!);
  //   double longitude = double.parse(currentLng!);

  //   // await Future.delayed(Duration(milliseconds: 300));
  //   try {
  //     placemarks = await geocoding.placemarkFromCoordinates(
  //       latitude,
  //       longitude,
  //     );
  //     geocoding.Placemark place = placemarks[0];

  //     fullAddress =
  //         '${place.street}, ${place.thoroughfare}, ${place.subLocality} ${place.locality}, ${place.postalCode}, ${place.country}';

  //     return fullAddress;
  //   } catch (e) {
  //     // showSnackBar(2, 'Address was not retrieved, please fill out manually');
  //   }
  // }
}
