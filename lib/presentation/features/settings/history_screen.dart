import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../app_setting/app_setting.dart';
import '../../../locator.dart';
import '../../widgets/widgets.dart';
import '../history/history.dart';
import '../profile/profile.dart';
import '../wrapper.dart';
import 'setting.dart';

class HistoryParameters {
  final int selectedTab;

  const HistoryParameters({required this.selectedTab});
}

class HistoryScreen extends StatefulWidget {
  final HistoryParameters parameters;
  const HistoryScreen({super.key, required this.parameters});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: colorWhite,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, profileState) {
          if (profileState is ProfileProcessing) {
            return Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: colorWhite,
              child: LoadingWidget(),
            );
          }
          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) return;
              Navigator.of(context).pushNamedAndRemoveUntil(
                OderRoutes.wallet,
                (Route<dynamic> route) => true,
              );
            },
            child: OderScaffold(
              systemUiOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: colorRedDark,
                statusBarIconBrightness: Brightness.light,
              ),
              title: Text(
                'Transaction History',
                style: TextStyle(
                  fontFamily: fontFamilyMain,
                  color: colorWhite,
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                ),
                textScaler: TextScaler.linear(scaleFactor),
              ),
              appBarColor: colorRedDark,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                color: colorWhite,
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    OderRoutes.wallet,
                    (Route<dynamic> route) => true,
                  );
                },
              ),
              body: HistoryWrapper(selectedTab: widget.parameters.selectedTab),
              bottomMenuIndex: 3,
              isShow: false,
            ),
          );
        },
      ),
    );
  }
}

class HistoryWrapper extends StatefulWidget {
  final int selectedTab;

  const HistoryWrapper({super.key, required this.selectedTab});

  @override
  OderWrapperState<HistoryWrapper> createState() =>
  // ignore: no_logic_in_create_state
  _HistoryWrapperState(selectedTab);
}

class _HistoryWrapperState extends OderWrapperState<HistoryWrapper> {
  // ignore: prefer_typing_uninitialized_variables
  var selectedTab;

  _HistoryWrapperState(this.selectedTab);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProfileBloc>(
          create: (context) {
            return ProfileBloc(userRepository: sl())..add(ProfileLoad());
          },
        ),
        BlocProvider<HistoryBloc>(
          create: (context) {
            return HistoryBloc()..add(
              selectedTab == 0
                  ? CreditHistoryTransactionsLoad()
                  : HistoryTransactionsLoad(),
            );
          },
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<HistoryBloc, HistoryState>(
            listener: (context, state) {
              fToast = FToast();
              fToast.init(context);

              if (state is HistoryError) {
                showErrorToast(state.error, context);
              }
              if (state is HistorySessionError) {
                sessionExpiredLogOut(state.error);
              }
            },
          ),
        ],
        child: getPageView(<Widget>[
          HistoryView(changeView: changePage, selectedTab: selectedTab),
        ]),
      ),
    );
  }
}
