import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app_setting/app_setting.dart';
import '../../../../data/data.dart';
import '../../../widgets/widgets.dart';
import '../../../widgets/extensions/outlet_favourite_view.dart';
import '../../ordering/ordering.dart';
import '../../outlet/outlet.dart';

class FavOutletView extends StatefulWidget {
  final Function changeView;
  const FavOutletView({super.key, required this.changeView});

  @override
  State<FavOutletView> createState() => _FavOutletViewState();
}

class _FavOutletViewState extends State<FavOutletView>
    with SingleTickerProviderStateMixin {
  List<OutletFavourite> outletFav = [];
  // int totalFav = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return OderScaffold(
      bottomMenuIndex: 3,
      isShow: true,
      showAppbar: true,
      systemUiOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: colorWhite,
        statusBarIconBrightness: Brightness.dark,
      ),
      title: Text(
        'Favourite Brands\' Outlets',
        style: TextStyle(
          fontFamily: fontFamilyMain,
          color: colorBlack,
          fontWeight: FontWeight.w400,
          fontSize: 15,
        ),
        textScaler: TextScaler.linear(scaleFactor),
      ),
      canClick: true,
      isCenterTitle: true,
      body: BlocConsumer<OrderingBloc, OrderingState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is OrderingInitial || state is OrderingLoading) {
            return LoadingWidget();
          }

          if (state is OrderingStarted) {
            BlocProvider.of<OrderingBloc>(context).add(OutletFavListLoad());
          }

          if (state is FavOutletListLoaded) {
            outletFav = state.outletListFav;

            return Column(
              children: [
                Container(
                  width: ScreenSize.width,
                  padding: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: marginHorizontal,
                  ),
                  decoration: BoxDecoration(
                    border: Border.symmetric(
                      horizontal: BorderSide(color: colorCountGrey),
                    ),
                  ),
                  child: Text(
                    '${outletFav.length} items found',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: colorNoVoucherGrey,
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: _buildFavOutletView(context, state),
                  ),
                ),
              ],
            );
          }

          return LoadingWidget();
        },
      ),
    );
  }

  /* --------------------------------------------------------------------------- All Voucher ListView section */
  Widget _buildFavOutletView(BuildContext context, OrderingState state) {
    /* IF API call success and not empty, set List variable */
    if (state is FavOutletListLoaded) {
      outletFav = state.outletListFav;
    }

    /* the extension for gridview voucher */
    var outletFavListTiles = outletFav
        .map(
          (favOutlet) => favOutlet.getOutletFavListTile(
            context: context,
            onTap: () {
              // Storage().distance = favOutlet.distance;

              Navigator.of(context)
                  .pushNamed(
                    OderRoutes.outletDetails,
                    arguments: OutletDetailsParameters(
                      outletId: favOutlet.id!,
                      outlet: favOutlet.outletName!,
                    ),
                  )
                  .then((value) {
                    setState(() {
                      BlocProvider.of<OrderingBloc>(context)
                        ..isReload = true
                        ..add(OrderingCheck());
                    });
                  });
            },
            onTapFav: () {
              setState(() {
                Storage().page = 'wallet_outletFav';
                BlocProvider.of<OrderingBloc>(context).add(
                  OutletAddRemoveFavouriteLoad(
                    outletId: favOutlet.id!.toString(),
                    merchantId: '',
                  ),
                );

                // Slidable.of(context)!.close();
              });
              // if (outletFav.any((fav) => fav.id == favOutlet.id)) {
              //   // print('ISCONTAIN: TRUE');

              //   outletFav
              //       .removeWhere((outletFav) => outletFav.id == favOutlet.id);

              //   String encodedFavList = jsonEncode(outletFav);

              //   setState(() {
              //     _saveList(encodedFavList);
              //   });
              // }
            },
          ),
        )
        .toList(growable: false);

    /* My Voucher design */
    return outletFav.isNotEmpty
        ? Container(
          padding: EdgeInsets.only(bottom: 30),
          child: ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 10),
            physics: NeverScrollableScrollPhysics(),
            itemCount: outletFav.length,
            itemBuilder: (context, index) {
              return outletFavListTiles[index];
            },
            separatorBuilder: (context, index) {
              return Divider(
                color: colorPermissionGrey,
                thickness: 1,
                indent: marginHorizontal,
                endIndent: marginHorizontal,
              );
            },
          ),
        )
        : Center(
          child: SizedBox(
            height:
                ScreenSize.height -
                kToolbarHeight -
                MediaQuery.of(context).padding.top -
                kBottomNavigationBarHeight -
                85,
            // color: colorBabyBlue,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: ScreenSize.width * 0.2,
                  width: ScreenSize.width * 0.2,
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
                  "No Available Brands' Outlet",
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

  // Future<void> _saveList(favList) async {
  //   await Storage().secureStorage.write(key: 'favList', value: favList);
  // }
}
