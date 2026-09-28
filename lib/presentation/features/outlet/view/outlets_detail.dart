import 'dart:io';

import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:map_launcher/map_launcher.dart';

import '../../../../app_setting/app_setting.dart';
import '../../../../data/data.dart';
import '../../../../util/utils.dart';
import '../../../widgets/extensions/outlet_operation_view.dart';
import '../../../widgets/extensions/outlet_voucher_view.dart';
import '../../../widgets/widgets.dart';
import '../../ordering/ordering.dart';
import '../../rewards/reward.dart';
import '../../voucher/voucher.dart';
import '../outlet.dart';

class OutletDetailsView extends StatefulWidget {
  final Function? changeView;
  final String? outletId;

  const OutletDetailsView({super.key, this.changeView, this.outletId});

  @override
  State<OutletDetailsView> createState() => _OutletDetailsViewState();
}

class _OutletDetailsViewState extends State<OutletDetailsView>
    with TickerProviderStateMixin {
  bool isProcessing = false;
  bool isFavouriteClick = false;
  bool isFavClick = false;
  List<Operation> operations = [];
  List<VoucherOutlet> outletVoucher = [];
  List<OutletFav> outletFav = [];
  // int _current = 0;
  late TabController _tabController;
  late ScrollController _scrollController;
  // final CarouselController _controller = CarouselController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  void setProcessingStatus(bool processing) {
    setState(() {
      isProcessing = processing;
    });
  }

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);

    _tabController.addListener(() {
      setState(() {
        // _selectedIndex = _tabController.index;
        _tabController.index;
      });
    });
  }

  /* --------------------------------------------------------------------------- dispose - Called when this object is removed from the tree permanently. */
  @override
  void dispose() {
    super.dispose();

    _scrollController.dispose();
  }

  Future _refreshData() async {
    await Future.delayed(Duration(seconds: 1));
    BlocProvider.of<OutletBloc>(
      // ignore: use_build_context_synchronously
      context,
    ).add(OutletDetailsLoad(outletId: widget.outletId!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      body: Container(
        color: colorBackground,
        // margin: EdgeInsets.symmetric(horizontal: marginHorizontal),
        child: BlocConsumer<OutletBloc, OutletState>(
          listener: (context, state) {
            if (state is OutletDetailsLoaded) {
              isFavClick = false;
              //   isFavouriteClick = state.details.isFavourite!;
              //   // print('CALL LISTENER: ${state.details}');
              //   debugPrint('CALL LISTENER: ${state.details}');
            }
          },
          builder: (context, state) {
            if (state is OutletDetailsLoaded) {
              var detail = state.details;
              var outletId = detail.id;
              var distance =
                  Storage().distance!.isNotEmpty ? Storage().distance : '0';
              var dist = double.parse(distance!);
              var operation = state.details.operations!.length;
              var availableVoucher = state.details.vouchers!.length;
              isFavouriteClick = detail.isFavourite!;

              if (outletId != null) {
                return RefreshIndicator(
                  key: _refreshIndicatorKey,
                  onRefresh: _refreshData,
                  child: NestedScrollView(
                    controller: _scrollController,
                    headerSliverBuilder: (context, innerBoxIsScrolled) {
                      return [
                        /* ----------------------------------------------------------------- Tabbar section */
                        SliverPersistentHeader(
                          pinned: true,
                          delegate: SliverAppBarDelegate(
                            minHeight: ScreenSize.height * 0.06,
                            maxHeight: ScreenSize.height * 0.06,
                            child: Container(
                              decoration: BoxDecoration(
                                color: colorBackground,
                                border: Border(
                                  bottom: BorderSide(color: colorGreyBox),
                                ),
                              ),
                              child: TabBar(
                                // isScrollable: true,
                                controller: _tabController,
                                unselectedLabelColor: Color(0xFF929292),
                                unselectedLabelStyle: TextStyle(
                                  fontSize: 12.0,
                                  fontFamily: fontFamilyMain,
                                  fontWeight: FontWeight.w600,
                                ),
                                labelColor: colorBlack,
                                labelStyle: TextStyle(
                                  fontSize: 12.0,
                                  fontFamily: fontFamilyMain,
                                  fontWeight: FontWeight.w600,
                                ),
                                indicatorColor: colorMulberry,
                                indicatorWeight: 5,
                                labelPadding: EdgeInsets.symmetric(
                                  horizontal: 0.0,
                                ),
                                tabs: [
                                  Tab(
                                    // text: 'My Vo/ucher',
                                    child: Container(
                                      alignment: Alignment.center,
                                      color: colorTransparent,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: ScreenSize.width * 0.05,
                                            margin: EdgeInsets.only(right: 3),
                                            child: Image(
                                              image: AssetImage(
                                                'assets/icons/outlet/about_tab.png',
                                              ),
                                              color:
                                                  _tabController.index == 0
                                                      ? colorBlack
                                                      : null,
                                            ),
                                          ),
                                          Text(
                                            'About',
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Tab(
                                    // text: 'Subscription Plan',
                                    child: Container(
                                      color: colorTransparent,
                                      alignment: Alignment.center,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: ScreenSize.width * 0.05,
                                            margin: EdgeInsets.only(right: 3),
                                            child: Image(
                                              image: AssetImage(
                                                'assets/icons/outlet/deals_tab.png',
                                              ),
                                              color:
                                                  _tabController.index == 1
                                                      ? colorBlack
                                                      : null,
                                            ),
                                          ),
                                          Text(
                                            'Deals',
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ];
                    },
                    /* ------------------------------------------------------------------- Body Sliver */
                    body: TabBarView(
                      controller: _tabController,
                      children: [
                        SingleChildScrollView(
                          child: Container(
                            // height: height * 0.12,
                            color: colorBackground,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    Container(
                                      // color: colorBabyBlue,
                                      margin: EdgeInsets.only(bottom: 5),
                                      height: ScreenSize.width * 0.46,
                                      child: CachedImage(
                                        imageUrl: detail.image!,
                                        boxFit: BoxFit.cover,
                                      ),
                                    ),
                                    BlocConsumer<OrderingBloc, OrderingState>(
                                      listener: (context, state) {
                                        if (state is FavouriteAddRemove) {
                                          setState(() {
                                            // isFavouriteClick =
                                            //     state.favOutlet['data']
                                            //         ['isFavourite'];

                                            BlocProvider.of<OutletBloc>(context)
                                              ..isReload = true
                                              ..add(
                                                OutletDetailsLoad(
                                                  outletId: widget.outletId!,
                                                ),
                                              );
                                          });
                                        }
                                      },
                                      builder: (context, state) {
                                        return Positioned(
                                          top: 27,
                                          right: 30,
                                          // bottom: -5,
                                          // right: 10,
                                          child: InkWell(
                                            child: Container(
                                              padding: EdgeInsets.all(6),
                                              decoration: BoxDecoration(
                                                color: colorBackground,
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: colorGreyBorder,
                                                ),
                                              ),
                                              child:
                                                  isFavClick == false
                                                      ? isFavouriteClick ==
                                                              false
                                                          // outletFav.any(
                                                          //         (e) => e.id == outletId)
                                                          ? Icon(
                                                            Icons
                                                                .favorite_border,
                                                            size: 28,
                                                            color:
                                                                colorCountGrey,
                                                          )
                                                          : Icon(
                                                            Icons.favorite,
                                                            size: 28,
                                                            color:
                                                                colorRaspberyRed,
                                                          )
                                                      : Container(
                                                        padding: EdgeInsets.all(
                                                          2,
                                                        ),
                                                        width:
                                                            ScreenSize.width *
                                                            0.063,
                                                        height:
                                                            ScreenSize.width *
                                                            0.063,
                                                        child:
                                                            CircularProgressIndicator(
                                                              color: colorSoftGrey
                                                                  .withValues(
                                                                    alpha: 0.5,
                                                                  ),
                                                            ),
                                                      ),
                                            ),
                                            onTap: () {
                                              setState(() {
                                                isFavClick = true;

                                                Storage().page =
                                                    'outlet_details';
                                                BlocProvider.of<OrderingBloc>(
                                                  context,
                                                ).add(
                                                  OutletAddRemoveFavouriteLoad(
                                                    outletId:
                                                        widget.outletId
                                                            .toString(),
                                                    merchantId:
                                                        detail.merchantId
                                                            .toString(),
                                                  ),
                                                );
                                              });
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: marginHorizontal,
                                    vertical: 15,
                                  ),
                                  child:
                                      detail.links!.isNotEmpty
                                          ? Row(
                                            children: [
                                              Expanded(
                                                child: InkWell(
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          vertical: 10,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: colorGoldButton,
                                                      border: Border.all(
                                                        color: colorWhite,
                                                        width: 2,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            20,
                                                          ),
                                                      boxShadow: const [
                                                        BoxShadow(
                                                          color: colorGreyBox,
                                                          blurRadius: 3.0,
                                                          offset: Offset(
                                                            0.0,
                                                            2.0,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          height:
                                                              ScreenSize
                                                                  .height *
                                                              0.02,
                                                          padding:
                                                              EdgeInsets.only(
                                                                right: 5,
                                                              ),
                                                          child: Image(
                                                            image: AssetImage(
                                                              'assets/icons/location/map_pin.webp',
                                                            ),
                                                            color: colorBlack,
                                                          ),
                                                        ),
                                                        Text(
                                                          'Map',
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontFamily:
                                                                fontFamilyMain,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color:
                                                                colorOutletAddressLabelGrey,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    launchMapDirection(detail);
                                                  },
                                                ),
                                              ),
                                              SizedBox(
                                                width: ScreenSize.width * 0.05,
                                              ),
                                              Expanded(
                                                child: InkWell(
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          vertical: 10,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: colorDeliveryGreen,
                                                      border: Border.all(
                                                        color: colorWhite,
                                                        width: 2,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            20,
                                                          ),
                                                      boxShadow: const [
                                                        BoxShadow(
                                                          color: colorGreyBox,
                                                          blurRadius: 3.0,
                                                          offset: Offset(
                                                            0.0,
                                                            2.0,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          height:
                                                              ScreenSize
                                                                  .height *
                                                              0.02,
                                                          padding:
                                                              EdgeInsets.only(
                                                                right: 5,
                                                              ),
                                                          child: Image(
                                                            image: AssetImage(
                                                              'assets/icons/location/delivery.webp',
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          'Delivery',
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontFamily:
                                                                fontFamilyMain,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: colorWhite,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    launchDelivery(
                                                      context,
                                                      detail,
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          )
                                          : Container(
                                            width:
                                                ScreenSize.width / 2 -
                                                ScreenSize.width * 0.04,
                                            padding: EdgeInsets.all(3),
                                            alignment: Alignment.centerRight,
                                            child: InkWell(
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                  vertical: 10,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: colorGoldButton,
                                                  border: Border.all(
                                                    color: colorWhite,
                                                    width: 2,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  boxShadow: const [
                                                    BoxShadow(
                                                      color: colorGreyBox,
                                                      blurRadius: 3.0,
                                                      offset: Offset(0.0, 2.0),
                                                    ),
                                                  ],
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      height:
                                                          ScreenSize.height *
                                                          0.02,
                                                      padding: EdgeInsets.only(
                                                        right: 5,
                                                      ),
                                                      child: Image(
                                                        image: AssetImage(
                                                          'assets/icons/location/map_pin.webp',
                                                        ),
                                                        color: colorBlack,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Map',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontFamily:
                                                            fontFamilyMain,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color:
                                                            colorOutletAddressLabelGrey,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              onTap: () {
                                                launchMapDirection(detail);
                                              },
                                            ),
                                          ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: marginHorizontal,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(
                                                top: 10,
                                                bottom: 5,
                                              ),
                                              child: Text(
                                                detail.merchantName!,
                                                style: TextStyle(
                                                  color: colorBlack,
                                                  fontFamily: fontFamilyMain,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                textAlign: TextAlign.center,
                                                textScaler: TextScaler.linear(
                                                  scaleFactor,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              detail.place!,
                                              style: TextStyle(
                                                color: colorBlack,
                                                fontFamily: fontFamilyMain,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              // textAlign: TextAlign.center,
                                              textScaler: TextScaler.linear(
                                                scaleFactor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      dist == 0
                                          ? SizedBox()
                                          : Text(
                                            '${dist.toStringAsFixed(2)} km',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: colorTextGrey,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: fontFamilyMain,
                                            ),
                                            textScaler: TextScaler.linear(
                                              scaleFactor,
                                            ),
                                          ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                    marginHorizontal,
                                    20,
                                    marginHorizontal,
                                    20,
                                  ),
                                  child: HtmlWidget(detail.merchantDesc!),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(
                                    marginHorizontal,
                                    20,
                                    marginHorizontal,
                                    10,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: ScreenSize.height * 0.02,
                                        margin: EdgeInsets.only(right: 20),
                                        color: colorTransparent,
                                        child: Image(
                                          image: AssetImage(
                                            'assets/icons/outlet/location.png',
                                          ),
                                          color: colorBlackTab,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          detail.address!,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: colorBlackTab,
                                            fontFamily: fontFamilyMain,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          textAlign: TextAlign.start,
                                          textScaler: TextScaler.linear(
                                            scaleFactor,
                                          ),
                                          maxLines: 3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  // margin: EdgeInsets.only(top: 10),
                                  padding: EdgeInsets.fromLTRB(
                                    marginHorizontal,
                                    10,
                                    marginHorizontal,
                                    10,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: ScreenSize.height * 0.02,
                                        margin: EdgeInsets.only(right: 20),
                                        color: colorTransparent,
                                        child: Image(
                                          image: AssetImage(
                                            'assets/icons/outlet/contact.png',
                                          ),
                                          color: colorBlackTab,
                                        ),
                                      ),
                                      Text(
                                        detail.contact!,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: colorBlackTab,
                                          fontFamily: fontFamilyMain,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.start,
                                        textScaler: TextScaler.linear(
                                          scaleFactor,
                                        ),
                                        maxLines: 3,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                    marginHorizontal,
                                    10,
                                    marginHorizontal,
                                    20,
                                  ),
                                  // height: height * 0.2,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: ScreenSize.height * 0.02,
                                        margin: EdgeInsets.only(right: 20),
                                        color: colorTransparent,
                                        child: Image(
                                          image: AssetImage(
                                            'assets/icons/outlet/time.png',
                                          ),
                                          color: colorBlackTab,
                                        ),
                                      ),
                                      operation != 0
                                          ? Expanded(
                                            child: Container(
                                              child: _buildOperationListView(
                                                context,
                                                state,
                                              ),
                                            ),
                                          )
                                          : Container(
                                            margin: EdgeInsets.symmetric(
                                              vertical: 10,
                                            ),
                                          ),
                                    ],
                                  ),
                                ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                        SingleChildScrollView(
                          child:
                              availableVoucher != 0
                                  ? Container(
                                    margin: EdgeInsets.symmetric(
                                      vertical: 20,
                                      horizontal: marginHorizontal,
                                    ),
                                    child: _buildOutletVoucherListView(
                                      context,
                                      state,
                                    ),
                                  )
                                  : SizedBox(
                                    height: ScreenSize.height * 0.7,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: ScreenSize.width * 0.2,
                                          width: ScreenSize.width * 0.2,
                                          // margin: EdgeInsets.only(top: height / 4),
                                          padding: EdgeInsets.symmetric(
                                            vertical: ScreenSize.height / 8,
                                            horizontal: ScreenSize.width,
                                          ),
                                          decoration: const BoxDecoration(
                                            image: DecorationImage(
                                              fit: BoxFit.contain,
                                              image: AssetImage(
                                                'assets/icons/outlet/no_merchant_voucher.webp',
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: ScreenSize.height * 0.03,
                                        ),
                                        Text(
                                          "No Voucher Yet",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w300,
                                            color: colorNoVoucherGrey,
                                          ),
                                          textAlign: TextAlign.center,
                                          textScaler: TextScaler.linear(
                                            scaleFactor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Container();
            }
            return Container(
              height: ScreenSize.height * 0.8,
              width: MediaQuery.of(context).size.width,
              color: colorWhite,
              child: Center(
                child: CircularProgressIndicator(color: colorDisableGrey),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildOperationListView(BuildContext context, OutletState state) {
    if (state is OutletDetailsLoaded) {
      operations = state.details.operations!;

      var operationTiles = operations
          .map(
            (operation) => operation.getOutletOperationTile(context: context),
          )
          .toList(growable: false);

      return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: operations.length,
        itemBuilder: (context, index) {
          return operationTiles[index];
        },
        // ),
      );
    }
    return Container();
  }

  Widget _buildOutletVoucherListView(BuildContext context, OutletState state) {
    if (state is OutletDetailsLoaded) {
      // outletVoucher = state.details.vouchers!;

      outletVoucher =
          state.details.vouchers!
              .where((voucher) => voucher.purchaseMethod != 'redeemable')
              .toList();

      var voucherTiles = outletVoucher
          .map(
            (outletVoucher) => outletVoucher.getOutletVoucherTile(
              context: context,
              onTap: () {
                setProcessingStatus(true);

                Navigator.of(context)
                    .pushNamed(
                      OderRoutes.rewardDetails,
                      arguments: RewardDetailsParameters(
                        rewardId: outletVoucher.id!,
                        title: state.details.merchantName!,
                        indexPage: 3,
                      ),
                    )
                    .then((value) {
                      setProcessingStatus(false);
                    });
              },
            ),
          )
          .toList(growable: false);

      return outletVoucher.isNotEmpty
          ? ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: outletVoucher.length,
            itemBuilder: (context, index) {
              return voucherTiles[index];
            },
            // ),
          )
          : SizedBox(
            height: ScreenSize.height * 0.7,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: ScreenSize.width * 0.2,
                  width: ScreenSize.width * 0.2,
                  // margin: EdgeInsets.only(top: height / 4),
                  padding: EdgeInsets.symmetric(
                    vertical: ScreenSize.height / 8,
                    horizontal: ScreenSize.width,
                  ),
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.contain,
                      image: AssetImage(
                        'assets/icons/outlet/no_merchant_voucher.webp',
                      ),
                    ),
                  ),
                ),
                SizedBox(height: ScreenSize.height * 0.03),
                Text(
                  "No Voucher Yet",
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
          );
    }
    return Container();
  }

  launchMapDirection(OutletDetails detail) async {
    final availableMaps = await MapLauncher.installedMaps;

    if (!mounted) return;
    showModalBottomSheet(
      context: context,
      backgroundColor: colorBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                height:
                    availableMaps.length > 1
                        ? ScreenSize.height * 0.35
                        : ScreenSize.height * 0.25,
                padding: EdgeInsets.fromLTRB(10, 30, 10, 20),
                child: CustomScrollView(
                  primary: false,
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: ScreenSize.width,
                            padding: EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 20,
                            ),
                            color: colorBackground,
                            child: Text('Open with: '),
                          ),
                          Container(
                            padding: EdgeInsets.only(bottom: 20),
                            color: colorBackground,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Wrap(
                                  children: <Widget>[
                                    for (var map in availableMaps)
                                      ListTile(
                                        onTap:
                                            () => map.showDirections(
                                              destination: Coords(
                                                double.parse(detail.latitude!),
                                                double.parse(detail.longitude!),
                                              ),
                                              destinationTitle: detail.address,
                                              // origin: Coords(),
                                              // waypoints:
                                              directionsMode:
                                                  DirectionsMode.driving,
                                            ),
                                        title: Text(map.mapName),
                                        leading: SvgPicture.asset(
                                          map.icon,
                                          height: 30.0,
                                          width: 30.0,
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  launchDelivery(BuildContext context, OutletDetails detail) async {
    double itemSpacing =
        Platform.isIOS ? ScreenSize.width * 0.04 : ScreenSize.width / 11;

    showModalBottomSheet(
      context: context,
      backgroundColor: colorBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          height: ScreenSize.height * 0.25,
          padding: EdgeInsets.fromLTRB(10, 30, 10, 20),
          child: Column(
            children: [
              Container(
                width: ScreenSize.width,
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                color: colorBackground,
                child: Text('Order via: '),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 20),
                color: colorBackground,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      color: colorBackground,
                      margin: EdgeInsets.symmetric(
                        horizontal: marginHorizontal,
                      ),
                      child: Row(
                        // mainAxisAlignment: detail.links!.length == 4
                        //     ? MainAxisAlignment.spaceBetween
                        //     : MainAxisAlignment.start,
                        children: <Widget>[
                          // for (var link in detail.links!)
                          for (int i = 0; i < detail.links!.length; i++)
                            InkWell(
                              child: Container(
                                width:
                                    detail.links![i].type != 'Others'
                                        ? ScreenSize.width * 0.15
                                        : ScreenSize.width * 0.1,
                                height:
                                    detail.links![i].type != 'Others'
                                        ? ScreenSize.width * 0.15
                                        : ScreenSize.width * 0.1,
                                decoration: BoxDecoration(
                                  color:
                                      detail.links![i].type != 'Others'
                                          ? colorBackground
                                          : colorMulberry,
                                  shape: BoxShape.circle,
                                ),
                                margin: EdgeInsets.only(
                                  right:
                                      i == detail.links!.length - 1
                                          ? 0
                                          : itemSpacing,
                                ),
                                padding: EdgeInsets.all(
                                  detail.links![i].type != 'Others' ? 0 : 7,
                                ),
                                child: Image(
                                  image:
                                      detail.links![i].type == 'Grab'
                                          ? AssetImage(
                                            'assets/icons/location/food_grab.webp',
                                          )
                                          : detail.links![i].type == 'Foodpanda'
                                          ? AssetImage(
                                            'assets/icons/location/food_panda.webp',
                                          )
                                          : detail.links![i].type == 'Whatsapp'
                                          ? AssetImage(
                                            'assets/icons/location/food_ws.webp',
                                          )
                                          : AssetImage(
                                            'assets/icons/outlet/link-order.webp',
                                          ),
                                ),
                              ),
                              onTap: () async {
                                if (detail.links![i].type != 'Others') {
                                  if (!await launchUrl(
                                    Uri.parse(detail.links![i].url!),
                                    mode: LaunchMode.externalApplication,
                                  )) {
                                    throw 'Could not launch this link';
                                  }
                                } else {
                                  Navigator.push(
                                    context,
                                    NoAnimationPageRoute(
                                      builder: (context) {
                                        // Directly return WidgetWebView, as it contains its own Scaffold and AppBar
                                        return WidgetWebView(
                                          widgetUrl: detail.links![i].url!,
                                          title: ' ',
                                        );
                                      },
                                    ),
                                  );
                                  // Navigator.push(
                                  //   context,
                                  //   NoAnimationPageRoute(
                                  //     builder: (context) {
                                  //       return Scaffold(
                                  //         appBar: AppBar(
                                  //           systemOverlayStyle:
                                  //               SystemUiOverlayStyle(
                                  //                 statusBarColor: colorWhite,
                                  //                 systemNavigationBarColor:
                                  //                     colorWhite,
                                  //               ),

                                  //           leading: IconButton(
                                  //             icon: Icon(Icons.close),
                                  //             onPressed: () {
                                  //               Navigator.pop(context);
                                  //             },
                                  //           ),
                                  //           backgroundColor: colorBackground,
                                  //           iconTheme: IconThemeData(
                                  //             color: colorBlack,
                                  //           ),
                                  //           elevation: 0,
                                  //         ),
                                  //         body: SafeArea(
                                  //           child: WidgetWebView(
                                  //             widgetUrl: detail.links![i].url!,
                                  //             // widgetUrl:
                                  //             //     'https://mini.makantrip.com/event_checkin_demo?token=4ffacfc4eb46b5a7330e047435b2830512377f165053437cb5faa02cca93da81',
                                  //           ),
                                  //         ),
                                  //       );
                                  //     },
                                  //   ),
                                  // );
                                }
                              },
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Future<void> _saveList(favList) async {
  //   await Storage().secureStorage.write(key: 'favList', value: favList);
  // }
}
