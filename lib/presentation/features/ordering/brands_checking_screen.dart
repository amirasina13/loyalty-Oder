import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../app_setting/app_setting.dart';
import '../../../locator.dart';
import '../../widgets/widgets.dart';
import '../maintenance/maintenance_screen.dart';
import '../profile/profile.dart';
import '../wrapper.dart';
import 'ordering.dart';

class BrandsCheckingScreen extends StatefulWidget {
  const BrandsCheckingScreen({super.key});

  @override
  State<BrandsCheckingScreen> createState() => _BrandsCheckingScreenState();
}

class _BrandsCheckingScreenState extends State<BrandsCheckingScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, profileState) {
        if (profileState is ProfileProcessing) {
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: colorWhite,
            child: LoadingWidget(),
          );
        }

        return OderScaffold(
          body: BrandsCheckingWrapper(),
          extendBodyBehindAppBar: true,
          appBarColor: colorTransparent,
          bottomMenuIndex: 1,
          isShow: true,
          canClick: false,
        );
      },
    );
  }
}

class BrandsCheckingWrapper extends StatefulWidget {
  const BrandsCheckingWrapper({super.key});

  @override
  OderWrapperState<BrandsCheckingWrapper> createState() =>
      _BrandsCheckingWrapperState();
}

class _BrandsCheckingWrapperState
    extends OderWrapperState<BrandsCheckingWrapper> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrderingBloc>(
      create: (context) {
        Storage().orderingCheck = 0;
        return OrderingBloc(orderingRepository: sl())..add(OrderingCheck());
      },
      child: BlocConsumer<OrderingBloc, OrderingState>(
        listener: (context, state) {
          fToast = FToast();
          fToast.init(context);

          if (state is OrderingError) {
            showErrorToast(state.error, context);
            // ErrorDialog.showErrorDialog(context, state.error);
          }
          if (state is OrderingSessionError) {
            sessionExpiredLogOut(state.error);
          }
          if (state is OrderingNetworkError) {
            showErrorToast('No internet connection', context);
            // ErrorIconDialog.showErrorDialog(context, 'No internet connection');
            Navigator.of(context).pushNamedAndRemoveUntil(
              OderRoutes.home,
              (Route<dynamic> route) => false,
            );
          }
          /* ------------------------------------------------------------------- Listen to maintenance error, navigate to maintenance page */
          if (state is OrderingMaintenanceError) {
            Navigator.pushAndRemoveUntil<void>(
              context,
              MaterialPageRoute<void>(
                builder:
                    (BuildContext context) => MaintenanceScreen(
                      parameters: MaintenanceParameters(message: state.message),
                    ),
              ),
              ModalRoute.withName('/'),
            );
          }

          if (state is OrderingLocationRequested) {
            YesNoDialog.showYesNoDialog(
              context,
              'Enable Location Service',
              Platform.isAndroid ? androidLocText : iosLocText,
              colorBlack,
              TextAlign.justify,
              _buildEnableButton(context),
            );
          }

          // print('BRANDCHECK: $state');
          // if (state is OutletsLoaded) {
          //   fullAddress = state.address;
          // }

          if (state is OrderingStarted) {
            // BlocProvider.of<OrderingBloc>(context).add(NearbyLoad());
            // // BlocProvider.of<OrderingBloc>(context).add(BrandsLoad());

            Navigator.of(context).pushNamedAndRemoveUntil(
              OderRoutes.orderingMerchant,
              (Route<dynamic> route) => false,
              arguments: OrderingScreenParameters(selectedTab: 0),
            );
          }

          // if (state is BrandsLoaded) {
          //   //   // if (state.merchants.length == 1) {
          //   //   //   Storage().brandId = state.merchants[0].id!;
          //   //   //   Storage().brandName = state.merchants[0].name;
          //   //   //   Storage().brandCheck = 'orderingOutlet';
          //   //   //   Navigator.of(context).pushNamedAndRemoveUntil(
          //   //   //        OderRoutes.orderingOutlet, (Route<dynamic> route) => false,
          //   //   //       arguments: OrderingOutletParameters(
          //   //   //           brandsId: state.merchants[0].id!));
          //   //   // } else {
          //   //   Storage().brandCheck = 'orderingMerchant';
          //   Navigator.of(context).pushNamedAndRemoveUntil(
          //      OderRoutes.orderingMerchant,
          //     (Route<dynamic> route) => false,
          //     // arguments: OrderingParameters(merchantList: state.merchants),
          //   );
          //   //   // }
          // }
        },
        builder: (context, state) {
          return LoadingWidget();
          // return getPageView(<Widget>[
          //   OrderingView(
          //     changeView: changePage,
          //   ),
          // ]);
        },
      ),
    );
  }

  // For enable buton in location dialog
  Widget _buildEnableButton(BuildContext context) {
    return OderStyleButton(
      title: 'Continue',
      backgroundColor: mainColor,
      onPressed: () async {
        BlocProvider.of<OrderingBloc>(context).add(OrderingLocationEnable());
        Navigator.pop(context);
      },
    );
  }
}
