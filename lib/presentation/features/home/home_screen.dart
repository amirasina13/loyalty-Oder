import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:intl/date_symbol_data_local.dart';

import '../../../app_setting/app_setting.dart';
import '../../../data/data.dart';
import '../../../locator.dart';
import '../../widgets/widgets.dart';
import '../maintenance/maintenance.dart';
import '../profile/profile.dart';
import '../wrapper.dart';
import 'home.dart';

class HomeScreenNew extends StatefulWidget {
  const HomeScreenNew({super.key});

  @override
  State<HomeScreenNew> createState() => _HomeScreenNewState();
}

class _HomeScreenNewState extends State<HomeScreenNew> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      // onWillPop: () => showExitPopup(context, height),
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        showExitPopup(context, ScreenSize.height);
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(systemNavigationBarColor: colorWhite),
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileProcessing) {
              return Container(
                height: ScreenSize.height,
                width: ScreenSize.width,
                color: colorWhite,
              );
            }
            return OderScaffold(
              showAppbar: false,
              extendBodyBehindAppBar: true,
              body: BlocProvider<HomeBloc>(
                create: (context) {
                  return HomeBloc(
                    userRepository: RepositoryProvider.of<UserRepository>(
                      context,
                    ),
                    rewardRepository: RepositoryProvider.of<RewardRepository>(
                      context,
                    ),
                  )..add(HomeLoad());
                },
                child: HomeWrapperNew(),
              ),
              bottomMenuIndex: 0,
              isShow: true,
              canClick: false,
            );
          },
        ),
      ),
    );
  }

  Future<bool> showExitPopup(context, height) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: colorBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: marginHorizontal),
          insetPadding: EdgeInsets.symmetric(horizontal: marginHorizontal),
          content: SizedBox(
            height: height * 0.22,
            width: ScreenSize.width * 0.7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 30),
                      child: Text(
                        "Exit App",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: colorRedLight,
                        ),
                      ),
                    ),
                    InkWell(
                      child: Container(
                        margin: EdgeInsets.only(bottom: 30),
                        child: Icon(Icons.close, color: colorRedLight),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                Text(
                  "Do you want to exit?",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: colorOutletAddressLabelGrey,
                  ),
                ),
                SizedBox(height: 25),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        highlightColor: colorBackground,
                        child: Container(
                          height: height * 0.05,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: colorGoldButton,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Text(
                            "Yes",
                            style: TextStyle(
                              fontSize: 16,
                              color: colorOutletAddressLabelGrey,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        onTap: () {
                          exit(0);
                        },
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: InkWell(
                        highlightColor: colorBackground,
                        child: Container(
                          height: height * 0.05,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: colorRaspberyRed,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Text(
                            "No",
                            style: TextStyle(
                              fontSize: 16,
                              color: colorWhite,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class HomeWrapperNew extends StatefulWidget {
  const HomeWrapperNew({super.key});

  @override
  OderWrapperState<HomeWrapperNew> createState() => _HomeWrapperNewState();
}

class _HomeWrapperNewState extends OderWrapperState<HomeWrapperNew> {
  var now = DateTime.now();
  var format = DateFormat('yyyy-MM-dd');
  late String dateNow = format.format(now);
  // final CarouselController _carouselController =
  //     CarouselController();
  CarouselSliderController carouselController = CarouselSliderController();
  int _current = 0;
  loc.Location? _location;
  final Permission permission = Permission.locationWhenInUse;
  String packageName = '';

  @override
  void initState() {
    super.initState();

    initializeDateFormatting();
    loadPackageInfo();
  }

  void loadPackageInfo() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      packageName = packageInfo.packageName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (context) {
        final homeBloc = HomeBloc(
          userRepository: sl<UserRepository>(),
          rewardRepository: sl<RewardRepository>(),
        );

        // Add multiple events to the BLoC
        homeBloc.add(HomeLoad());
        // homeBloc.add(VoucherBrandLoad());

        return homeBloc;
      },

      child: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) async {
          fToast = FToast();
          fToast.init(context);

          if (state is HomeMaintenanceError) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              OderRoutes.maintenanceScreen,
              (Route<dynamic> route) => false,
              arguments: MaintenanceParameters(message: state.message),
            );
          }

          if (state is HomeLoaded) {
            // print('voucherId: $voucherId');
            // ProfileBloc(userRepository: sl()).add(ProfileLoad());
            var banners = state.homePage.banners;

            if (banners!.isShow == true && banners.path!.isNotEmpty) {
              showDialog(
                context: context,
                builder:
                    (context) => GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Dialog(
                        backgroundColor: colorTransparent,
                        insetPadding: EdgeInsets.all(20),
                        child: StatefulBuilder(
                          builder: (
                            BuildContext context,
                            StateSetter setState,
                          ) {
                            return Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.bottomCenter,
                              children: [
                                CarouselSlider(
                                  items:
                                      banners.path!.map((item) {
                                        return Builder(
                                          builder: (BuildContext context) {
                                            return Container(
                                              // width: width,
                                              alignment:
                                                  Alignment
                                                      .centerRight, // where to position the child
                                              child: CachedImage(
                                                imageUrl: item.path!,
                                              ),
                                            );
                                          },
                                        );
                                      }).toList(),
                                  carouselController: carouselController,
                                  options: CarouselOptions(
                                    aspectRatio: 2 / 3,
                                    // height: MediaQuery.of(context).size.height,
                                    viewportFraction: 1.0,
                                    enableInfiniteScroll: false,
                                    autoPlay: true,
                                    // autoPlay:
                                    //     banners.path!.length > 1 ? true : false,
                                    autoPlayInterval: Duration(seconds: 5),
                                    onPageChanged: (index, reason) {
                                      setState(() {
                                        _current = index;
                                      });
                                    },
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children:
                                      banners.path!.asMap().entries.map((
                                        entry,
                                      ) {
                                        return GestureDetector(
                                          onTap:
                                              () => carouselController
                                                  .animateToPage(entry.key),
                                          child: Container(
                                            width: 12.0,
                                            height: 12.0,
                                            margin: EdgeInsets.symmetric(
                                              vertical: 8.0,
                                              horizontal: 4.0,
                                            ),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color:
                                                  _current == entry.key
                                                      ? colorWhite
                                                      : colorUsedGray,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                ),
                                Positioned(
                                  top: -35,
                                  right: 0,
                                  // bottom: -46,
                                  child: InkWell(
                                    child: Container(
                                      //   height: height * 0.05,
                                      //   width: width * 0.09,
                                      padding: EdgeInsets.zero,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        // color: colorBlack,
                                        border: Border.all(
                                          color: colorWhite,
                                          width: 2,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.close_rounded,
                                        color: colorWhite,
                                        size: 20,
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
              );
            }

            // Instantiate NewVersion manager object (Using GCP Console app as example)
            final newVersion = NewVersionPlus(
              iOSId: packageName, //'com.hdi365.makantrip',
              androidId: packageName, //'com.hdi365.makantrip',
              iOSAppStoreCountry: 'MY',
              androidPlayStoreCountry: 'MY',
            );

            // You can let the plugin handle fetching the status and showing a dialog,
            // or you can fetch the status and display your own dialog, or no dialog.

            basicStatusCheck(newVersion);

            // Check location enable or not
            bool serviceEnabled = await _isLocationServiceEnabled();
            // print('SERVICE ENABLE 1: $serviceEnabled');
            if (!serviceEnabled) {
              if (Storage().lastUpdateLoc.isEmpty &&
                  Storage().lastUpdateLoc != dateNow) {
                Storage().lastUpdateLoc = dateNow;

                locationDialog();
              }
            } else {
              await getCurrentLocation();
            }
          }

          if (state is HomeError) {
            // ignore: use_build_context_synchronously
            showErrorToast(state.error, context);
          }
          if (state is HomeSessionError) {
            sessionExpiredLogOut(state.error);
          }
        },
        builder: (context, state) {
          return getPageView(<Widget>[
            HomeViewNew(
              token: state is HomeLoaded ? state.token : '',
              changeView: changePage,
            ),
            // SearchView(changeView: changePage),
          ]);
        },
      ),
    );
  }

  basicStatusCheck(NewVersionPlus newVersion) async {
    final status = await newVersion.getVersionStatus();
    if (status != null) {
      if (Storage().lastUpdateCheck.isEmpty &&
          Storage().lastUpdateCheck != dateNow) {
        Storage().lastUpdateCheck = dateNow;

        if (mounted) {
          newVersion.showAlertIfNecessary(
            context: context,
            launchModeVersion: LaunchModeVersion.external,
          );
        }

        // in staging code, call a dummy alert instead
        // SuccessDialog.showSuccessDialog(context, Storage().lastUpdateCheck);
      }
    }
  }

  Future<bool> _isLocationServiceEnabled() async {
    _location ??= loc.Location();
    LocationAccuracyStatus? accuracy;

    // region fail-safe
    bool serviceEnabled;

    serviceEnabled = await _location!.serviceEnabled();

    loc.PermissionStatus permissionGranted = await _location!.hasPermission();

    await Geolocator.getLocationAccuracy()
        .then((value) {
          if (value == LocationAccuracyStatus.reduced) {
            accuracy = LocationAccuracyStatus.reduced;
            // return serviceEnabled && value == LocationAccuracyStatus.reduced;
          }
        })
        .catchError((e) {});

    if (permissionGranted == loc.PermissionStatus.denied ||
        permissionGranted == loc.PermissionStatus.deniedForever) {
      if (accuracy == LocationAccuracyStatus.reduced) {
        return (serviceEnabled && accuracy == LocationAccuracyStatus.reduced);
      }
    }

    if (Platform.isIOS &&
        permissionGranted == loc.PermissionStatus.grantedLimited) {
      return (serviceEnabled &&
          permissionGranted == loc.PermissionStatus.grantedLimited);
    }

    return (serviceEnabled &&
        permissionGranted == loc.PermissionStatus.granted);
  }

  getCurrentLocation() async {
    List<geocoding.Placemark> placemarks;

    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 100,
      timeLimit: Duration(seconds: 5),
    );

    Geolocator.getCurrentPosition(locationSettings: locationSettings)
        .then((Position position) async {
          setState(() {
            Storage().latitude = position.latitude.toString();
            Storage().longitude = position.longitude.toString();
          });

          placemarks = await geocoding.placemarkFromCoordinates(
            position.latitude,
            position.longitude,
          );
          geocoding.Placemark place = placemarks[0];

          Storage().address =
              '${place.street}, ${place.thoroughfare}, ${place.subLocality} ${place.locality}, ${place.postalCode}, ${place.country}';
        })
        .catchError((e) async {
          await Geolocator.getLastKnownPosition()
              .then((value) async {
                Storage().latitude = value!.latitude.toString();
                Storage().longitude = value.longitude.toString();

                placemarks = await geocoding.placemarkFromCoordinates(
                  value.latitude,
                  value.longitude,
                );
                geocoding.Placemark place = placemarks[0];

                Storage().address =
                    '${place.street}, ${place.thoroughfare}, ${place.subLocality} ${place.locality}, ${place.postalCode}, ${place.country}';
              })
              .catchError((e) async {
                Storage().latitude = '3.1390';
                Storage().longitude = '101.6869';

                placemarks = await geocoding.placemarkFromCoordinates(
                  3.1390,
                  101.6869,
                );
                geocoding.Placemark place = placemarks[0];

                Storage().address =
                    '${place.street}, ${place.thoroughfare}, ${place.subLocality} ${place.locality}, ${place.postalCode}, ${place.country}';
              });
        });
  }

  locationDialog() {
    YesNoDialog.showYesNoDialog(
      context,
      'Enable Location Service',
      Platform.isAndroid ? androidLocText : iosLocText,
      colorBlack,
      TextAlign.justify,
      OderStyleButton(
        title: 'Continue',
        backgroundColor: mainColor,
        onPressed: () async {
          Navigator.pop(context);

          bool serviceEnabled = await _location!.serviceEnabled();
          if (!serviceEnabled) {
            serviceEnabled = await _location!.requestService();
            if (!serviceEnabled) {
              Storage().locPermission = 'disable';
              getCurrentLocation();
              return;
            }
          }

          loc.PermissionStatus permissionGranted =
              await _location!.hasPermission();
          if (permissionGranted == loc.PermissionStatus.denied) {
            permissionGranted = await _location!.requestPermission();

            if (permissionGranted == loc.PermissionStatus.granted) {
              loc.Location.instance.changeSettings(
                accuracy: (loc.LocationAccuracy.high),
              );

              getCurrentLocation();
            }

            if (permissionGranted != loc.PermissionStatus.granted) {
              getCurrentLocation();
            }
          }
        },
      ),
    );
  }
}
