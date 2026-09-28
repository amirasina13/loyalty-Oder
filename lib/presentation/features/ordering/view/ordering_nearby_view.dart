import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../app_setting/app_setting.dart';
import '../../../../data/data.dart';
import '../../../widgets/widgets.dart';
import '../../../widgets/extensions/nearby_list_view.dart';
import '../../authentication/authentication.dart';
import '../../maintenance/maintenance.dart';
import '../../outlet/outlet_details_screen.dart';
// import '../../voucher/voucher.dart';
import '../ordering.dart';

class OrderingNearbyView extends StatefulWidget {
  final Function? changeView;

  const OrderingNearbyView({super.key, this.changeView});

  @override
  State<OrderingNearbyView> createState() => _OrderingNearbyViewState();
}

class _OrderingNearbyViewState extends State<OrderingNearbyView>
    with TickerProviderStateMixin {
  String gotChangeValue = '';
  NearbyOutlet? nearbyOutlet;
  List<NearbyOutletList> nearbyOutletList = <NearbyOutletList>[];
  List<NearbyOutletList> nearbyOutletDisplay = <NearbyOutletList>[];
  var nearbyListTiles = [];
  var searchOutletTiles = [];
  late final ScrollController _scrollControllerNearby;
  // late OrderingBloc _orderingBloc;

  @override
  void initState() {
    super.initState();

    final bloc = context.read<OrderingBloc>();

    if (!bloc.isNearbyFetching) {
      debugPrint('>>> LOADING NEXT PAGE');
      bloc
        ..isFirstLoad = false
        ..isNearbyFetching = true
        ..add(NearbyLoad());
    }

    _scrollControllerNearby = ScrollController();
    _scrollControllerNearby.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollControllerNearby.hasClients) return;

    final position = _scrollControllerNearby.position;

    debugPrint('SCROLL: ${position.pixels} / ${position.maxScrollExtent}');

    final maxScroll = _scrollControllerNearby.position.maxScrollExtent;
    final currentScroll = _scrollControllerNearby.position.pixels;

    if (currentScroll >= maxScroll - 200) {
      debugPrint('>>> REACHED PAGINATION THRESHOLD');
      final bloc = context.read<OrderingBloc>();

      if (!bloc.isNearbyFetching) {
        debugPrint('>>> LOADING NEXT PAGE');
        bloc
          ..isFirstLoad = false
          ..isNearbyFetching = true
          ..add(NearbyLoad());
      }
    }
  }

  @override
  void dispose() {
    _scrollControllerNearby.removeListener(_onScroll);
    _scrollControllerNearby.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // //Add this to give height
      // height: ScreenSize.height,
      color: colorBackground,
      // child: BlocProvider<OrderingBloc>(
      //   create: (context) {
      //     final bloc = OrderingBloc(orderingRepository: sl());

      //     _orderingBloc = bloc;

      //     bloc.add(NearbyLoad());

      //     return bloc;
      //     // return OrderingBloc(orderingRepository: sl())..add(NearbyLoad());
      //   },
      child: BlocConsumer<OrderingBloc, OrderingState>(
        listener: (context, state) {
          if (state is OrderingError) {
            showErrorToast(state.error, context);
            // ErrorDialog.showErrorDialog(
            //     context, state.error);
          }
          if (state is OrderingSessionError) {
            sessionExpiredLogOut(state.error);
          }
          /* --------------------------------------------- Listen to maintenance error, navigate to maintenance page */
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
        },
        builder: (context, state) {
          return Container(
            // height: height * 0.3,
            margin: EdgeInsets.only(bottom: Platform.isAndroid ? 30 : 70),
            child: _buildTabNearby(context),
          );
        },
      ),
      // ),
    );
  }

  Widget _buildTabNearby(BuildContext context) {
    return BlocConsumer<OrderingBloc, OrderingState>(
      listener: ((context, state) {
        fToast = FToast();
        fToast.init(context);

        if (state is NearbyListStop) {
          showPaginationToast('No more outlets', context);
        }

        if (state is NearbyLoaded) {
          // first check if api returns any historical records,
          if (state.outlets.outlets != null &&
              state.outlets.outlets!.isNotEmpty) {
            // if history.records is neither null or empty
            // append to the global records variable (List<nearbyOutlets>)
            nearbyOutletList.addAll(state.outlets.outlets!);
            BlocProvider.of<OrderingBloc>(context).isNearbyFetching = false;
          }

          // comment: instead of working with the records from api,
          // records.add(state.history.records);
          // comment: work with the global variable that has the records from API added above
          nearbyListTiles = nearbyOutletList;
          BlocProvider.of<OrderingBloc>(context).isNearbyFetching = false;
        }

        // if (state is NearbySearchStop) {
        //   nearbyOutletDisplay = nearbyOutletList.where((brands) {
        //     var outletPlace = brands.merchantName!.toLowerCase();
        //     return outletPlace.contains(editingController.text.toLowerCase());
        //   }).toList();

        //   if (editingController.text.isEmpty) {
        //     nearbyOutletList = nearbyOutletList;
        //   }
        //   // else{
        //   //   nearbyOutletList
        //   // }
        // }
      }),
      builder: (context, state) {
        if (state is OrderingLoading) {
          return LoadingWidget();
        }

        // if (state is NearbyLoaded) {
        //   // first check if api returns any historical records,
        //   if (state.outlets.outlets != null &&
        //       state.outlets.outlets!.isNotEmpty) {
        //     // if history.records is neither null or empty
        //     // append to the global records variable (List<nearbyOutlets>)
        //     nearbyOutletList.addAll(state.outlets.outlets!);
        //     BlocProvider.of<OrderingBloc>(context).isNearbyFetching = false;
        //   }

        //   // comment: instead of working with the records from api,
        //   // records.add(state.history.records);
        //   // comment: work with the global variable that has the records from API added above
        //   nearbyListTiles = nearbyOutletList;
        //   BlocProvider.of<OrderingBloc>(context).isNearbyFetching = false;
        // }

        if (state is NearbyEmpty) {
          return buildEmptyContainer();
        }

        return Column(
          children: [
            Expanded(child: Container(child: _buildNearbyList(context, state))),
            state is NearbyNextLoading ? LoadingWidget() : Container(),
          ],
        );
      },
    );
  }

  Widget _buildNearbyList(BuildContext context, OrderingState state) {
    if (state is NearbyLoaded) {
      nearbyOutlet = state.outlets;
    }

    var nearbyListTiles = nearbyOutletList
        .map(
          (nearbyList) => nearbyList.getNearbyListTile(
            context: context,
            state: state,
            onTap: () {
              Storage().distance = nearbyList.distance;
              Navigator.of(context)
                  .pushNamed(
                    OderRoutes.outletDetails,
                    arguments: OutletDetailsParameters(
                      outletId: nearbyList.id!,
                      outlet: nearbyList.place!,
                    ),
                  )
                  .then((value) {});
            },
          ),
        )
        .toList(growable: false);

    // var searchOutletTiles = nearbyOutletDisplay
    //     .map(
    //       (nearbyList) => nearbyList.getNearbyListTile(
    //         context: context,
    //         state: state,
    //         onTap: () {
    //           Storage().distance = nearbyList.distance;
    //           Navigator.of(context)
    //               .pushNamed(
    //                 OderRoutes.outletDetails,
    //                 arguments: OutletDetailsParameters(
    //                   outletId: nearbyList.id!,
    //                   outlet: nearbyList.place!,
    //                 ),
    //               )
    //               .then((value) {});
    //         },
    //       ),
    //     )
    //     .toList(growable: false);

    return nearbyOutletList.isNotEmpty
        ? ListView.builder(
          padding: EdgeInsets.only(bottom: 40, top: 20),
          // padding: EdgeInsets.zero,
          // shrinkWrap: true,
          // controller: scrollControllerNearby,
          controller: _scrollControllerNearby,
          itemCount: nearbyOutletList.length,
          // searchController.text.isEmpty
          //     ? nearbyOutletList.length
          //     : nearbyOutletDisplay.length,
          itemBuilder: (BuildContext context, int index) {
            return nearbyOutletDisplay.isEmpty
                ? nearbyListTiles[index]
                : searchOutletTiles[index];
          },
        )
        : buildEmptyContainer();
  }

  Widget buildEmptyContainer() {
    return Center(
      child: Container(
        color: colorBackground,
        // height: height * 0.5,
        margin: EdgeInsets.only(top: ScreenSize.height * 0.35),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: ScreenSize.width * 0.2,
              width: ScreenSize.width * 0.2,
              // margin: EdgeInsets.only(top: height / 4),
              // padding:
              //     EdgeInsets.symmetric(vertical: height / 8, horizontal: width),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.contain,
                  image: AssetImage(
                    'assets/icons/outlet/no_merchant_outlet.webp',
                  ),
                ),
              ),
            ),
            SizedBox(height: ScreenSize.height * 0.03),
            Text(
              "No Available Nearby Outlet",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w300,
                color: colorNoVoucherGrey,
              ),
              textAlign: TextAlign.center,
              textScaler: TextScaler.linear(scaleFactor),
            ),
          ],
        ),
      ),
    );
  }

  // This function is called whenever the text field changes
  searchBrands(String text) {
    text = text.toLowerCase();

    if (text.isNotEmpty) {
      nearbyOutletDisplay =
          nearbyOutletList.where((brands) {
            var outletPlace = brands.merchantName!.toLowerCase();
            var outleAddress = brands.address!.toLowerCase();
            return outletPlace.contains(text) || outleAddress.contains(text);
          }).toList();

      setState(() {
        nearbyOutletDisplay;
      });
    } else {
      setState(() {
        nearbyOutletDisplay = [];
      });
    }
  }

  void sessionExpiredLogOut(String error) {
    showErrorToast('$error\nYou will be logged out.', context);
    BlocProvider.of<AuthenticationBloc>(context).add(AuthenticationLoggedOut());
    Navigator.of(context).pushNamedAndRemoveUntil(
      OderRoutes.login,
      (Route<dynamic> route) => false,
    );
  }
}
