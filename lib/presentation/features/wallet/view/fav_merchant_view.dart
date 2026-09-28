import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app_setting/app_setting.dart';
import '../../../../data/data.dart';
import '../../../widgets/widgets.dart';
import '../../../widgets/extensions/ordering_bookmark.dart';
import '../../ordering/ordering.dart';

class FavMerchantView extends StatefulWidget {
  final Function changeView;
  const FavMerchantView({super.key, required this.changeView});

  @override
  State<FavMerchantView> createState() => _FavMerchantViewState();
}

class _FavMerchantViewState extends State<FavMerchantView>
    with SingleTickerProviderStateMixin {
  List<MerchantBookmark> merchantBookmarkList = <MerchantBookmark>[];
  late final controller = SlidableController(this);

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
        'Following Merchant',
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
          if (state is OrderingStarted) {
            BlocProvider.of<OrderingBloc>(context).add(MerchantBookmarkLoad());
          }

          // if (state is OrderingInitial ||
          //     state is OrderingStarted ||
          //     state is OrderingLoading) {
          //   return LoadingWidget();
          // }

          if (state is MerchantBookmarkLoaded) {
            // var profileData = state.userQrcode;

            return SingleChildScrollView(
              child: _buildRewardWishlistView(context, state),
            );
          }

          return LoadingWidget();
        },
      ),
    );
  }

  /* --------------------------------------------------------------------------- All Voucher ListView section */
  Widget _buildRewardWishlistView(BuildContext context, OrderingState state) {
    /* IF API call success and not empty, set List variable */
    if (state is MerchantBookmarkLoaded) {
      merchantBookmarkList = state.merchantBookmark;
    }

    /* the extension for gridview voucher */
    var merchantBookmarkListTiles = merchantBookmarkList
        .map(
          (bookmarkList) => bookmarkList.getMerchantBookmarkListTile(
            context: context,
            onTap: () {
              Storage().brandName = bookmarkList.name;

              Navigator.of(context)
                  .pushNamed(
                    OderRoutes.orderingOutlet,
                    arguments: OrderingOutletParameters(
                      brandsId: bookmarkList.id!,
                    ),
                  )
                  .then((value) {
                    setState(() {
                      BlocProvider.of<OrderingBloc>(context)
                        ..isReload = true
                        ..add(OrderingCheck());
                    });
                  });
              Slidable.of(context)!.close();
            },
            onTapBookmark: () {
              setState(() {
                Storage().page = 'wallet_bookmark';
                BlocProvider.of<OrderingBloc>(context).add(
                  MerchantAddRemoveFavouriteLoad(
                    merchantId: bookmarkList.id!.toString(),
                  ),
                );

                // Slidable.of(context)!.close();
              });
            },
            // controllerSlider: controller,
          ),
        )
        .toList(growable: false);

    /* My Voucher design */
    return merchantBookmarkList.isNotEmpty
        ? Container(
          padding: EdgeInsets.only(bottom: 30),
          child: ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: NeverScrollableScrollPhysics(),
            itemCount: merchantBookmarkList.length,
            itemBuilder: (context, index) {
              return merchantBookmarkListTiles[index];
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
                30,
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
}
