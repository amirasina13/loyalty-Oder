import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

import 'app_setting/app_setting.dart';
import 'config/config.dart';
import 'data/data.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:navigation_history_observer/navigation_history_observer.dart';

import 'firebase_options_staging.dart' as firebase_staging;
import 'firebase_options_production.dart' as firebase_production;
import 'life_cycle_event.dart';
import 'locator.dart' as service_locator;
import 'locator.dart';

import 'presentation/features/authentication/authentication.dart';
import 'presentation/features/bulletin/bulletin.dart';
import 'presentation/features/country/country.dart';
import 'presentation/features/credits/credits.dart';
import 'presentation/features/delete_account/delete_acc.dart';
import 'presentation/features/forgot_pass/forgot_pass.dart';
import 'presentation/features/home/home.dart';
import 'presentation/features/login/login.dart';
import 'presentation/features/maintenance/maintenance.dart';
import 'presentation/features/notification/notification.dart';
import 'presentation/features/ordering/ordering.dart';
import 'presentation/features/otp/otp.dart';
import 'presentation/features/outlet/outlet.dart';
import 'presentation/features/profile/profile.dart';
import 'presentation/features/register/register.dart';
import 'presentation/features/rewards/reward.dart';
import 'presentation/features/security_pin/security_pin.dart';
import 'presentation/features/settings/setting.dart';
import 'presentation/features/setup/setup.dart';
import 'presentation/features/splash/splash.dart';
import 'presentation/features/verify_email/verify_email.dart';
import 'presentation/features/voucher/voucher.dart';
import 'presentation/features/wallet/wallet.dart';
import 'presentation/features/webview/webview_deeplink.dart';
import 'presentation/navigation_service.dart';
import 'presentation/widgets/extensions/location_screen.dart';
import 'presentation/widgets/widgets.dart';
import 'util/utils.dart';

// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
RemoteMessage? globalInitialMessage; // Global variable to store initial message

class SimpleBlocDelegate extends BlocObserver {
  @override
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    // ignore: avoid_print
    print(event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    // ignore: avoid_print
    print(transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    // ignore: avoid_print
    print(error);
  }
}

FutureOr<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  TempData.deeplink = '';
  Storage().setupDone = null;
  AppConfig.initialize();

  // Determine current flavor (e.g., using a build constant or environment variable)
  const String flavor = String.fromEnvironment(
    'flavor',
    defaultValue: 'staging',
  );

  if (flavor == 'staging') {
    await Firebase.initializeApp(
      options: firebase_staging.DefaultFirebaseOptions.currentPlatform,
    );
  } else if (flavor == 'production') {
    await Firebase.initializeApp(
      options: firebase_production.DefaultFirebaseOptions.currentPlatform,
    );
  } else {
    // Optional fallback: Good practice to catch if you forget to pass a flavor argument during build
    await Firebase.initializeApp(
      options: firebase_staging.DefaultFirebaseOptions.currentPlatform,
    );
  }

  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await NotificationService.instance.initialize();
  NotificationService.instance.getDeviceToken();

  globalInitialMessage = await FirebaseMessaging.instance.getInitialMessage();

  if (kDebugMode) {
    // Force disable Crashlytics collection while doing every day development.
    // Temporarily toggle this to true if you want to test crash reporting in your app.
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  } else {
    // Handle Crashlytics enabled status when not in Debug,
    // e.g. allow your users to opt-in to crash reporting.
  }

  if (Platform.isIOS) {
    DeepLinkHandler.listenForDeepLinkIOS();
  }

  await service_locator.init();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [
      SystemUiOverlay.top, // Shows Status bar
      SystemUiOverlay.bottom, // Shows Navigation bar
    ],
  );
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: colorTransparent,
      systemStatusBarContrastEnforced: true,
      statusBarIconBrightness: Brightness.dark,
      // statusBarBrightness: Brightness.light,
      systemNavigationBarColor: colorWhite,
    ),
  );

  CountryBloc countryBloc = CountryBloc();
  // await countryBloc.initialize();

  ProfileBloc profileBloc = ProfileBloc(userRepository: sl());

  HomeBloc homeBloc = HomeBloc(userRepository: sl(), rewardRepository: sl());

  WalletBloc walletBloc = WalletBloc(userRepository: sl());

  Bloc.observer = SimpleBlocDelegate();

  runApp(
    LifeCycleManager(
      child: MultiBlocProvider(
        providers: [
          // BlocProvider.value(value: notificationBloc),
          BlocProvider.value(value: profileBloc),
          BlocProvider.value(value: homeBloc),
          BlocProvider.value(value: countryBloc),
          BlocProvider.value(value: walletBloc),
          BlocProvider<AuthenticationBloc>(
            create:
                (context) => AuthenticationBloc(
                  profileBloc: BlocProvider.of<ProfileBloc>(context),
                  homeBloc: BlocProvider.of<HomeBloc>(context),
                  walletBloc: BlocProvider.of<WalletBloc>(context),
                  countryBloc: BlocProvider.of<CountryBloc>(context),
                  userRepository: sl(),
                  globalRepository: sl(),
                ),
          ),
        ],
        child: MultiRepositoryProvider(
          providers: [
            RepositoryProvider<UserRepository>(create: (context) => sl()),
          ],
          child: OderApp(),
        ),
      ),
    ),
  );
}

// ignore: use_key_in_widget_constructors
class OderApp extends StatelessWidget {
  // This widget is the root of your application.
  final RemoteMessage? initialMessage;

  const OderApp({super.key, this.initialMessage});

  @override
  Widget build(BuildContext context) {
    ScreenSize.init(context);
    initializeDateFormatting('en_US');
    NotificationService.context =
        context; // You can still initialize it here for other uses

    return MaterialApp(
      navigatorKey: sl<NavigationService>().navigatorKey, //navigatorKey,
      // navigatorObservers: [NavigationHistoryObserver()],
      navigatorObservers: [NavigationHistoryObserver(), routeObserver],
      onGenerateRoute: _registerRoutesWithParameters,
      debugShowCheckedModeBanner: false,
      title: appName,
      theme: OderTheme.of(context),
    );
  }

  Route _registerRoutesWithParameters(RouteSettings settings) {
    var route = settings.name;
    // ignore: prefer_typing_uninitialized_variables
    var parameters;

    if (settings.name == OderRoutes.splash) {
      return NoAnimationPageRoute(
        builder: (context) {
          return _buildSplashBloc(context, route);
        },
        settings: settings,
      );
    }
    if (settings.name == OderRoutes.register) {
      parameters = settings.arguments as RegisterParameters;
      return NoAnimationPageRoute(
        builder: (context) {
          return _buildRegisterBloc(parameters: parameters);
        },
        settings: settings,
      );
    }

    if (settings.name == OderRoutes.otpVerify) {
      parameters = settings.arguments as OtpVerifyParameters;
      return NoAnimationPageRoute(
        builder: (context) {
          return _buildOtpVerifyBloc(parameters: parameters);
        },
        settings: settings,
      );
    }
    if (settings.name == OderRoutes.login) {
      return NoAnimationPageRoute(
        builder: (context) {
          return _buildLoginBloc();
        },
        settings: settings,
      );
    }
    if (settings.name == OderRoutes.forgotPassword) {
      return NoAnimationPageRoute(
        builder: (context) {
          return _buildForgotPassBloc();
        },
        settings: settings,
      );
    }

    if (settings.name == OderRoutes.resetPassword) {
      parameters = settings.arguments as ResetPassParameters;
      return NoAnimationPageRoute(
        builder: (context) {
          return _buildForcePassBloc(parameters: parameters);
        },
        settings: settings,
      );
    }

    if (route != null) {
      if (settings.name == OderRoutes.deeplinkWebview) {
        parameters = settings.arguments as DeeplinkParameters;
      } else if (settings.name == OderRoutes.resetPassword) {
        parameters = settings.arguments as ResetPassParameters;
      } else if (settings.name == OderRoutes.setupEValid) {
        parameters = settings.arguments as EValidParameters;
      } else if (settings.name == OderRoutes.setupEValidOtp) {
        parameters = settings.arguments as EValidOtpParameters;
      } else if (settings.name == OderRoutes.setupCValid) {
        parameters = settings.arguments as CValidParameters;
      } else if (settings.name == OderRoutes.setupCValidOtp) {
        parameters = settings.arguments as CValidOtpParameters;
      } else if (settings.name == OderRoutes.setupVProfile) {
        parameters = settings.arguments as VProfileParameters;
      } else if (settings.name == OderRoutes.setupVMuslim) {
        parameters = settings.arguments as VMuslimParameters;
      } else if (settings.name == OderRoutes.verifyEmail) {
        parameters = settings.arguments as VerifyEmailParameters;
      } else if (settings.name == OderRoutes.rewardDetails) {
        parameters = settings.arguments as RewardDetailsParameters;
      } else if (settings.name == OderRoutes.rewardConfirm) {
        parameters = settings.arguments as RewardConfirmParameters;
      } else if (settings.name == OderRoutes.voucherDesc) {
        parameters = settings.arguments as VoucherDescParameters;
      } else if (settings.name == OderRoutes.voucher) {
        parameters = settings.arguments as VoucherParameters;
      } else if (settings.name == OderRoutes.voucherPastDetails) {
        parameters = settings.arguments as VoucherPastDetailsParameters;
      } else if (settings.name == OderRoutes.voucherfeedback) {
        parameters = settings.arguments as VoucherFeedbackParameters;
      } else if (settings.name == OderRoutes.outletDetails) {
        parameters = settings.arguments as OutletDetailsParameters;
      } else if (settings.name == OderRoutes.history) {
        parameters = settings.arguments as HistoryParameters;
      } else if (settings.name == OderRoutes.rewardOutletDetails) {
        parameters = settings.arguments as RewardOutletDetailsParameters;
      } else if (settings.name == OderRoutes.bulletinDetails) {
        parameters = settings.arguments as BulletinDetailsParameters;
      } else if (settings.name == OderRoutes.orderingMerchant) {
        parameters = settings.arguments as OrderingScreenParameters;
      } else if (settings.name == OderRoutes.orderingOutlet) {
        parameters = settings.arguments as OrderingOutletParameters;
      } else if (settings.name == OderRoutes.locationOutlet) {
        parameters = settings.arguments as LocationScreenParameters;
      } else if (settings.name == OderRoutes.maintenanceScreen) {
        parameters = settings.arguments as MaintenanceParameters;
      } else if (settings.name == OderRoutes.securityOtp) {
        parameters = settings.arguments as SecurityOtpParameters;
      } else if (settings.name == OderRoutes.searchAPIPage) {
        parameters = settings.arguments as SearchScreenParameters;
      }

      return NoAnimationPageRoute(
        builder: (context) {
          return _buildScreen(route, parameters: parameters);
        },
        settings: settings,
      );
    }
    return NoAnimationPageRoute(
      builder: (context) {
        return _buildLoginBloc();
      },
      settings: settings,
    );
  }

  BlocBuilder<AuthenticationBloc, AuthenticationState> _buildScreen(
    String route, {
    Object? parameters,
  }) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state is AuthenticationAuthenticated) {
          switch (route) {
            case OderRoutes.deeplinkWebview:
              return RedirectWebView(
                parameters: parameters as DeeplinkParameters,
              );
            case OderRoutes.resetPassword:
              return ResetPassScreen(
                parameters: parameters as ResetPassParameters,
              );
            case OderRoutes.wallet:
              return WalletScreen();
            case OderRoutes.favDeal:
              return FavDealScreen();
            case OderRoutes.favMerchant:
              return FavMerchantScreen();
            case OderRoutes.favOutlet:
              return FavOutletScreen();
            case OderRoutes.setting:
              return SettingScreen();
            case OderRoutes.profile:
              return ProfileScreen();
            case OderRoutes.verifyEmail:
              return VerifyEmailScreen(
                parameters: parameters as VerifyEmailParameters,
              );
            case OderRoutes.refer:
              return ReferScreen();
            case OderRoutes.rewardDetails:
              return RewardDetailsScreen(
                parameters: parameters as RewardDetailsParameters,
              );
            case OderRoutes.rewardConfirm:
              return RewardConfirmScreen(
                parameters: parameters as RewardConfirmParameters,
              );
            case OderRoutes.rewardOutletDetails:
              return RewardOutletDetailsScreen(
                parameters: parameters as RewardOutletDetailsParameters,
              );
            case OderRoutes.voucher:
              return VoucherScreen(parameters: parameters as VoucherParameters);
            case OderRoutes.voucherDesc:
              return VoucherDescScreen(
                parameters: parameters as VoucherDescParameters,
              );
            case OderRoutes.voucherPastDetails:
              return VoucherPastDetailsScreen(
                parameters: parameters as VoucherPastDetailsParameters,
              );
            case OderRoutes.voucherfeedback:
              return VoucherFeedbackScreen(
                parameters: parameters as VoucherFeedbackParameters,
              );
            case OderRoutes.history:
              return HistoryScreen(parameters: parameters as HistoryParameters);
            case OderRoutes.outletDetails:
              return OutletDetailsScreen(
                parameters: parameters as OutletDetailsParameters,
              );
            case OderRoutes.bulletin:
              return BulletinScreen();
            case OderRoutes.upcoming:
              return UpcomingScreen();
            case OderRoutes.bulletinDetails:
              return BulletinDetailsScreen(
                parameters: parameters as BulletinDetailsParameters,
              );
            case OderRoutes.deleteAccount:
              return DeleteAccScreen();
            case OderRoutes.deleteMobbile:
              return DeleteAccMobileScreen();
            case OderRoutes.creditOnline:
              return CreditOnlineScreen();
            case OderRoutes.pointConversion:
              return PointConversionScreen();
            case OderRoutes.securityCreate:
              return SecurityCreateScreen();
            case OderRoutes.securityChange:
              return SecurityPhoneScreen();
            case OderRoutes.securityOtp:
              return SecurityOtpScreen(
                parameters: parameters as SecurityOtpParameters,
              );
            case OderRoutes.securitySet:
              return SecuritySetScreen();
            case OderRoutes.securityConfirm:
              return SecurityConfirmScreen();
            case OderRoutes.passcodeKey:
              return PasscodeScreen();
            case OderRoutes.orderingMerchant:
              return OrderingScreen(
                parameters: parameters as OrderingScreenParameters,
              );
            case OderRoutes.orderingOutlet:
              return OrderingOutletScreen(
                parameters: parameters as OrderingOutletParameters,
              );
            case OderRoutes.nearbyOutlet:
              return OrderingNearbyScreen();
            case OderRoutes.setupEValid:
              return EValidScreen(parameters: parameters as EValidParameters);
            case OderRoutes.setupEValidOtp:
              return EValidOtpScreen(
                parameters: parameters as EValidOtpParameters,
              );
            case OderRoutes.setupCValid:
              return CValidScreen(parameters: parameters as CValidParameters);
            case OderRoutes.setupCValidOtp:
              return CValidOtpScreen(
                parameters: parameters as CValidOtpParameters,
              );
            case OderRoutes.setupVProfile:
              return VProfileScreen(
                parameters: parameters as VProfileParameters,
              );
            case OderRoutes.setupVMuslim:
              return VMuslimScreen(parameters: parameters as VMuslimParameters);
            case OderRoutes.locationOutlet:
              return LocationScreen(
                parameters: parameters as LocationScreenParameters,
              );
            case OderRoutes.searchAPIPage:
              return SearchScreen(
                parameters: parameters as SearchScreenParameters,
              );
            case OderRoutes.maintenanceScreen:
              return MaintenanceScreen(
                parameters: parameters as MaintenanceParameters,
              );
            case OderRoutes.serviceScreen:
              return ServiceErrorScreen();
          }
          return const HomeScreenNew();
        } else if (state is AuthenticationUnauthenticated) {
          return _buildLoginBloc();
        } else if (state is AuthMaintenanceError) {
          return MaintenanceScreen(
            parameters: MaintenanceParameters(message: state.message),
          );
        } else if (state is AuthenticationOnBoardingStarted) {
          return OnboardingScreen();
        } else {
          return _buildSplashBloc(context, route);
        }
      },
    );
  }

  BlocProvider<SplashBloc> _buildSplashBloc(BuildContext context, route) {
    var splashBloc = SplashBloc(
      authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
      countryBloc: BlocProvider.of<CountryBloc>(context),
    );

    splashBloc.add(SplashStart());

    return BlocProvider<SplashBloc>(
      create: (context) => splashBloc,
      child: SplashScreen(initialMessage: globalInitialMessage),
    );
  }

  BlocProvider<RegisterBloc> _buildRegisterBloc({Object? parameters}) {
    return BlocProvider<RegisterBloc>(
      create:
          (context) => RegisterBloc(
            userRepository: RepositoryProvider.of<UserRepository>(context),
          ),
      child: RegisterScreen(parameters: parameters as RegisterParameters),
    );
  }

  BlocProvider<OtpBloc> _buildOtpVerifyBloc({Object? parameters}) {
    return BlocProvider<OtpBloc>(
      create:
          (context) => OtpBloc(
            userRepository: RepositoryProvider.of<UserRepository>(context),
          ),
      child: OtpVerifyScreen(parameters: parameters as OtpVerifyParameters),
    );
  }

  BlocProvider<LoginBloc> _buildLoginBloc() {
    return BlocProvider<LoginBloc>(
      create:
          (context) => LoginBloc(
            userRepository: RepositoryProvider.of<UserRepository>(context),
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
          ),
      child: const LoginScreen(),
    );
  }

  BlocProvider<ForgotPassBloc> _buildForgotPassBloc() {
    return BlocProvider<ForgotPassBloc>(
      create:
          (context) => ForgotPassBloc(
            userRepository: RepositoryProvider.of<UserRepository>(context),
          ),
      child: ForgotPassScreen(),
    );
  }

  BlocProvider<ForgotPassBloc> _buildForcePassBloc({Object? parameters}) {
    return BlocProvider<ForgotPassBloc>(
      create:
          (context) => ForgotPassBloc(
            userRepository: RepositoryProvider.of<UserRepository>(context),
          ),
      child: ResetPassScreen(parameters: parameters as ResetPassParameters),
    );
  }
}
