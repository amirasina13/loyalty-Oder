import 'dart:convert';
import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
// import 'package:url_launcher/url_launcher.dart';

import '../../../../app_setting/app_setting.dart';
import '../../../../data/data.dart';
import '../../../../locator.dart';
import '../../../widgets/extensions/reward_merchant_view.dart';
import '../../../widgets/widgets.dart';
import '../../outlet/outlet.dart';
import '../../rewards/reward.dart';
import '../ordering.dart';

class OrderingOutletView extends StatefulWidget {
  final Function? changeView;
  final String brandsId;

  const OrderingOutletView({
    super.key,
    this.changeView,
    required this.brandsId,
  });

  @override
  State<OrderingOutletView> createState() => _OrderingOutletViewState();
}

class _OrderingOutletViewState extends State<OrderingOutletView>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  bool isProcessing = false;
  bool isBookmark = false;
  bool isFavOutlet = false;
  bool isDealEmpty = false;
  String fullAddress = '';
  int totalOutlets = 0;
  OutletInfo? outletInfo;
  List<OutletList> outlets = [];
  List<OutletList> outletDisplay = [];
  List<RewardMerchant> listVoucher = [];
  List<RewardMerchant> listVoucherDisplay = [];
  // List<dynamic> favoriteOutlet = [];
  List<OutletList> favOutlet = [];
  List<Map<String, dynamic>> newFavList = [];
  List<OutletFav> outletFav = [];
  List<GroupedItem> cachedOutletList = [];
  List<GroupedItem> displayList = [];
  TextEditingController editingController = TextEditingController();
  bool isClickFollow = false;
  // bool isClickOutletFav = false;
  bool tabChange = false;

  final Map<String, bool> _favouriteLoadingStates = {};
  final Map<String, bool> _favOutletLoadingStates = {};

  late TabController _tabController, stateController;

  final ScrollController _outerScrollController = ScrollController();
  final ScrollController dealScrollController = ScrollController();
  final ScrollController outletScrollController = ScrollController();
  final ScrollController menuScrollController = ScrollController();

  int selectedStateTabIndex = 0;

  List<String> cityState = [
    'Johor',
    'Kedah',
    'Kelantan',
    'Kuala Lumpur',
    'Labuan',
    'Melaka',
    'Negeri Sembilan',
    'Pahang',
    'Pulau Pinang',
    'Putrajaya',
    'Perak',
    'Perlis',
    'Sabah',
    'Sarawak',
    'Selangor',
    'Terengganu',
  ];

  void setProcessingStatus(bool processing) {
    setState(() {
      isProcessing = processing;
    });
  }

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 4, vsync: this, initialIndex: 0);

    _tabController.addListener(() {
      _tabController.index;
      if (_tabController.index == 1 && !_tabController.indexIsChanging) {
        // dispatch Bloc reload (optional if you already load in builder)
        context.read<OrderingBloc>().add(
          OutletOrderLoad(brandId: widget.brandsId),
        );

        // Reset the outer scroll AFTER frame so controller is attached
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_outerScrollController.hasClients) {
            _outerScrollController.jumpTo(0.0);
            stateController.index = 0;
          }
        });
      } else {
        if (_tabController.index == 2 && !_tabController.indexIsChanging) {
          // dispatch Bloc reload (optional if you already load in builder)
          context.read<OrderingBloc>().add(
            OutletOrderLoad(brandId: widget.brandsId),
          );

          // Reset the outer scroll AFTER frame so controller is attached
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_outerScrollController.hasClients) {
              _outerScrollController.jumpTo(0.0);
            }
          });
        }
      }
    });

    _getList();

    // Initialize with empty controller to avoid null issues
    stateController = TabController(length: 0, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _outerScrollController.dispose();
    dealScrollController.dispose();
    outletScrollController.dispose();
    menuScrollController.dispose();
    super.dispose();
  }

  // int _calculateTabLength() {
  //   int length = 4; // Always has "About" and "Gallery"
  //   if (!isDealEmpty) length++;
  //   if (totalOutlets > 0) length++;
  //   return length;
  // }

  @override
  bool get wantKeepAlive => true; // ✅ Keep state alive

  @override
  Widget build(BuildContext context) {
    super.build(context); // required with mixin

    return BlocConsumer<OrderingBloc, OrderingState>(
      listener: (context, state) {
        // If location is not enable, popup dialog
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

        if (state is OutletsLoaded) {
          isClickFollow = false;
          // isClickOutletFav = false;
        }

        if (state is OutletAddRemoveFavouriteLoaded) {
          setState(() {
            _favOutletLoadingStates.clear();
          });
        }
      },
      builder: (context, state) {
        if (state is OrderingStarted) {
          BlocProvider.of<OrderingBloc>(
            context,
          ).add(OutletOrderLoad(brandId: widget.brandsId));
          // BlocProvider.of<OrderingBloc>(context).add(BrandsLoad());
        }

        if (state is OrderingInitial ||
            state is OrderingLoading ||
            state is OrderingStarted) {
          // return Container(
          return LoadingWidget();
        }

        if (state is OutletsLoaded) {
          outletInfo = state.outlets;
          isBookmark = outletInfo!.merchant!.isFavourite!;

          // Main body

          return CustomScrollView(
            controller: _outerScrollController,
            slivers: [
              // ----------------------------------------------------------------- Dynamic appbar
              SliverAppBar(
                expandedHeight: ScreenSize.height * 0.17,
                collapsedHeight: ScreenSize.height * 0.17,
                floating: true,
                pinned: true,
                snap: true,
                elevation: 0,
                automaticallyImplyLeading: false,
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor:
                      colorTransparent, // this one will make the statusbar transparent
                  statusBarIconBrightness:
                      Brightness.light, //this will take care of the icon color
                ),
                flexibleSpace: Stack(
                  children: [
                    Container(
                      height: ScreenSize.height * 0.2,
                      padding: EdgeInsets.only(top: ScreenSize.height * 0.03),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/image/merchant_bg.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            child: IconButton(
                              icon: Icon(Icons.arrow_back_ios),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Stack(
                              children: [
                                Container(
                                  width: ScreenSize.width * 0.14,
                                  height: ScreenSize.width * 0.14,
                                  decoration: BoxDecoration(
                                    // shape: BoxShape.circle,
                                    color: colorBackground,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: colorGreyBox,
                                        blurRadius: 2.0,
                                        // offset: Offset(0.0, 2.0),
                                      ),
                                    ],
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        outletInfo!.merchant!.image!,
                                      ),
                                    ),
                                  ),
                                ),
                                outletInfo!.merchant!.isMuslim == true
                                    ? Positioned(
                                      top: ScreenSize.height * 0.003,
                                      right: ScreenSize.width * 0.01,
                                      child: HalalWidget(
                                        muslimCategory:
                                            outletInfo!
                                                .merchant!
                                                .muslimCategory!,
                                        width: ScreenSize.width * 0.03,
                                        isCircle: true,
                                      ),
                                    )
                                    : SizedBox(),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: ScreenSize.height * 0.06,
                              // width: width * 0.2,
                              // color: colorBabyBlue,
                              margin: EdgeInsets.only(right: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Flexible(
                                        // color: colorBabyBlue,
                                        child: Text(
                                          outletInfo!.merchant!.name!,
                                          style: TextStyle(
                                            // fontFamily: fontFamilyRoboto,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          textWidthBasis:
                                              TextWidthBasis.longestLine,
                                        ),
                                      ),
                                      Container(
                                        height: ScreenSize.height * 0.023,
                                        padding: EdgeInsets.only(left: 5),
                                        child: Image(
                                          image: AssetImage(
                                            'assets/icons/outlet/verify_merchant.png',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            child: Container(
                              width: ScreenSize.width * 0.24,
                              height: ScreenSize.height * 0.032,
                              margin: EdgeInsets.only(right: marginHorizontal),
                              decoration: BoxDecoration(
                                color: isBookmark ? colorWhite : colorMulberry,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [
                                  BoxShadow(
                                    color: colorGrey,
                                    blurRadius: 2.0,
                                    offset: Offset(0.0, 1.0),
                                  ),
                                ],
                              ),
                              child: Center(
                                child:
                                    isBookmark
                                        ? Text(
                                          isClickFollow == false
                                              ? ' Following'
                                              : 'Loading...',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w400,
                                            color: colorMulberry,
                                          ),
                                          textAlign: TextAlign.center,
                                        )
                                        : isClickFollow == false
                                        ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Icon(
                                              Icons.add,
                                              size: 15,
                                              color: colorWhite,
                                            ),
                                            Text(
                                              ' Follow',
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w400,
                                                color: colorWhite,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        )
                                        : Text(
                                          ' Loading...',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w400,
                                            color: colorWhite,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                isClickFollow = true;

                                Storage().page = 'merchant_bookmark';
                                BlocProvider.of<OrderingBloc>(context).add(
                                  MerchantAddRemoveFavouriteLoad(
                                    merchantId:
                                        outletInfo!.merchant!.id!.toString(),
                                  ),
                                );
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: ScreenSize.height * 0.05,
                        width: ScreenSize.width,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: colorWhite,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: TabBar(
                          controller: _tabController,
                          tabAlignment: TabAlignment.center,
                          // labelPadding: EdgeInsets.symmetric(horizontal: 30),
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicatorPadding: EdgeInsets.symmetric(
                            horizontal: 15,
                          ),
                          indicatorColor: colorRaspberyRed,
                          labelStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontFamily: fontFamilyMain,
                            color: colorRaspberyRed,
                          ),
                          unselectedLabelStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                            fontFamily: fontFamilyMain,
                            color: colorBlackText,
                          ),
                          tabs: [
                            Tab(text: 'About'),
                            Tab(text: 'Deals'),
                            Tab(text: 'Outlets'),
                            Tab(text: 'Gallery'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SliverFillRemaining(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    BlocBuilder<OrderingBloc, OrderingState>(
                      // listener: (context, state) {},
                      builder: (context, state) {
                        return SingleChildScrollView(
                          child: Container(
                            margin: EdgeInsets.only(top: 10),
                            color: colorBackground,
                            child: _buildAboutUs(context, state),
                          ),
                        );
                      },
                    ),
                    BlocProvider<RewardBloc>(
                      create: (context) {
                        return RewardBloc(
                          context: context,
                          rewardRepository: sl(),
                        )..add(RewardMerchantLoad(merchantId: widget.brandsId));
                      },
                      child: BlocConsumer<RewardBloc, RewardState>(
                        listener: (context, state) {},
                        builder: (context, state) {
                          return SingleChildScrollView(
                            controller: dealScrollController,
                            child: Container(
                              color: colorBackground,
                              margin: EdgeInsets.only(top: 10),
                              // padding: EdgeInsets.symmetric(
                              //     horizontal: marginHorizontal,
                              //     vertical: 10),
                              child: _buildVoucherListView(context, state),
                            ),
                          );
                        },
                      ),
                    ),
                    SingleChildScrollView(
                      controller: outletScrollController,
                      child: Container(
                        margin: EdgeInsets.only(top: 10),
                        // height: height * 0.12,
                        color: colorBackground,
                        child: _buildOutletList(context, state),
                      ),
                    ),
                    SingleChildScrollView(
                      controller: menuScrollController,
                      child: Container(
                        height:
                            MediaQuery.of(context).size.height - // total height
                            kToolbarHeight - // top AppBar height
                            kToolbarHeight -
                            // MediaQuery.of(context)
                            //     .padding
                            //     .top - // top padding
                            kBottomNavigationBarHeight -
                            kBottomNavigationBarHeight,
                        margin: EdgeInsets.only(top: 10),
                        color: colorBackground,
                        child: _buildGallery(context, state),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
        return Container();
      },
    );
  }

  Widget _buildOutletList(BuildContext context, OrderingState state) {
    List<String> newState = [];
    List<String> combineList = [];
    Map<String, List<OutletList>> groupedList = {};
    List<GroupedItem> newOutletList = [];

    if (state is OutletsLoaded) {
      outlets = state.outlets.outlets!;

      // Step 1: Get combined list of city states
      for (var outlet in outlets) {
        for (var city in cityState) {
          if (outlet.address?.contains(city) ?? false) {
            newState.add(city);
          }
        }
      }
      combineList = newState.toSet().toList();

      // Step 2: Group outlets by city
      for (var outlet in outlets) {
        for (var keyword in combineList) {
          if (outlet.address?.toLowerCase().contains(keyword.toLowerCase()) ??
              false) {
            groupedList.putIfAbsent(keyword, () => []).add(outlet);
          }
        }
      }

      // Step 3: Convert to GroupedItem list
      groupedList.forEach((keyword, outlet) {
        newOutletList.add(GroupedItem(keyword, outlet));
      });

      // Step 4: Only update stateController when list length changes
      if (stateController.length != newOutletList.length) {
        int oldIndex = stateController.index; // keep current index
        stateController.dispose();
        stateController = TabController(
          length: newOutletList.length,
          vsync: this,
          initialIndex: oldIndex.clamp(0, newOutletList.length - 1),
        );
      }

      // ✅ Update persistent displayList
      displayList = newOutletList;
    }

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Container(
        color: colorTransparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(
                marginHorizontal,
                10,
                marginHorizontal,
                10,
              ),
              child: TabBar(
                controller: stateController,
                isScrollable: true,
                unselectedLabelColor: colorDarkGray,
                unselectedLabelStyle: TextStyle(
                  fontSize: 11,
                  fontFamily: fontFamilyMain,
                  fontWeight: FontWeight.w500,
                ),
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: colorTransparent,
                ),
                labelColor: mainColor,
                labelPadding: EdgeInsets.only(right: 15),
                labelStyle: TextStyle(
                  fontSize: 11,
                  fontFamily: fontFamilyMain,
                  fontWeight: FontWeight.w700,
                ),
                onTap: (value) {
                  FocusManager.instance.primaryFocus?.unfocus();
                  tabChange = true;
                  Storage().isTabChange = tabChange;
                },
                tabs:
                    displayList.asMap().entries.map((entry) {
                      final index = entry.key;
                      final states = entry.value;
                      return Tab(
                        child: AnimatedBuilder(
                          animation: stateController,
                          builder: (context, child) {
                            final isSelected = stateController.index == index;
                            Color backgroundColor =
                                isSelected ? colorRaspberyRed : colorWhite;
                            return Container(
                              height: ScreenSize.height * 0.035,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                color: backgroundColor,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [
                                  BoxShadow(
                                    color: colorGreyBox,
                                    blurRadius: 4.0,
                                    offset: Offset(1.0, 1.0),
                                  ),
                                ],
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  states.cityState,
                                  style: TextStyle(
                                    color:
                                        isSelected ? colorWhite : colorTextGrey,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }).toList(),
              ),
            ),
            Divider(color: colorSocialBoxGrey),
            _buildOutletListView(context, state),
          ],
        ),
      ),
    );
  }

  Widget _buildOutletListView(BuildContext context, OrderingState state) {
    List<String> newState = [];
    List<String> combineList = [];
    // Create a Map to group filtered items
    Map<String, List<OutletList>> groupedList = {};
    // Create a new list to store the grouped items
    List<GroupedItem> newOutletList = [];

    if (state is OutletsLoaded) {
      outlets = state.outlets.outlets!;

      // Step 1: Get combined list of city states
      for (var outlet in outlets) {
        for (var city in cityState) {
          if (outlet.address?.contains(city) ?? false) {
            newState.add(city);
            combineList = newState.toSet().toList();
          }
        }
      }

      for (var item in outlets) {
        for (var keyword in combineList) {
          if (item.address!.toLowerCase().contains(keyword.toLowerCase())) {
            groupedList.putIfAbsent(keyword, () => []).add(item);
          }
        }
      }

      groupedList.forEach((keyword, outlet) {
        newOutletList.add(GroupedItem(keyword, outlet));
      });

      // ✅ Save to cache if we have valid data
      if (newOutletList.isNotEmpty) {
        cachedOutletList = newOutletList;
      }
    }

    // ✅ Use cache if current new list is empty
    final displayList =
        newOutletList.isEmpty ? cachedOutletList : newOutletList;

    return displayList.isEmpty || (stateController.length != displayList.length)
        ? Center(
          child: Container(
            color: colorBackground,
            height: ScreenSize.height * 0.5,
            // margin: EdgeInsets.symmetric(vertical: 10),
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
                        'assets/icons/outlet/no_merchant_outlet.webp',
                      ),
                    ),
                  ),
                ),
                SizedBox(height: ScreenSize.height * 0.03),
                Text(
                  "No Outlet Yet",
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
        )
        : Container(
          height: ScreenSize.height * 0.8,
          padding: EdgeInsets.only(bottom: Platform.isIOS ? 80 : 30),
          child: TabBarView(
            controller: stateController,
            children:
                displayList
                    .map(
                      (states) => ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: states.outletList.length,
                        itemBuilder: (context, index) {
                          final group = states.outletList[index];
                          final bool isFavOutletLoading =
                              _favOutletLoadingStates[group.id!] ?? false;

                          // if (state is OutletAddRemoveFavouriteLoaded) {
                          //   if (group.id == state.outletId) {
                          //     _favOutletLoadingStates.clear();
                          //   }
                          // }

                          return Column(
                            children: [
                              Stack(
                                clipBehavior: Clip.none,
                                alignment: Alignment.bottomCenter,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Storage().distance = group.distance;
                                      Navigator.of(context)
                                          .pushNamed(
                                            OderRoutes.outletDetails,
                                            arguments: OutletDetailsParameters(
                                              outletId: group.id!,
                                              outlet: group.place!,
                                            ),
                                          )
                                          .then((value) {
                                            if (!context.mounted) return;
                                            BlocProvider.of<OrderingBloc>(
                                              context,
                                            ).add(
                                              OutletOrderLoad(
                                                brandId: widget.brandsId,
                                              ),
                                            );
                                          });
                                    },
                                    child: Container(
                                      padding:
                                          Platform.isIOS
                                              ? EdgeInsets.symmetric(
                                                vertical: 16,
                                                horizontal: marginHorizontal,
                                              )
                                              : EdgeInsets.symmetric(
                                                vertical: 18,
                                                horizontal: marginHorizontal,
                                              ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Container(
                                              // width: width,
                                              color: colorBackground,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    group.place!,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: colorBlackTab,
                                                      fontFamily:
                                                          fontFamilyMain,
                                                    ),
                                                    textScaler:
                                                        TextScaler.linear(
                                                          scaleFactor,
                                                        ),
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                          top: 8,
                                                        ),
                                                        padding:
                                                            EdgeInsets.only(
                                                              right: 3,
                                                            ),
                                                        height:
                                                            ScreenSize.height *
                                                            0.02,
                                                        color: colorTransparent,
                                                        child: Image(
                                                          image: AssetImage(
                                                            'assets/icons/outlet/outlet_address.png',
                                                          ),
                                                          // color: colorCountGrey,
                                                        ),
                                                      ),
                                                      Container(
                                                        width:
                                                            ScreenSize.width *
                                                            0.83,
                                                        padding:
                                                            EdgeInsets.only(
                                                              top: 8,
                                                            ),
                                                        // color: colorGoldButton,
                                                        child: Text(
                                                          group.address!,
                                                          style: TextStyle(
                                                            fontSize: 9,
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            color:
                                                                colorTextGrey,
                                                            fontFamily:
                                                                fontFamilyMain,
                                                          ),
                                                          textScaler:
                                                              TextScaler.linear(
                                                                scaleFactor,
                                                              ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                      top: 5,
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                top: 6,
                                                              ),
                                                          child:
                                                              group.isOpen ==
                                                                      true
                                                                  ? Container(
                                                                    padding: EdgeInsets.symmetric(
                                                                      vertical:
                                                                          3,
                                                                      horizontal:
                                                                          7,
                                                                    ),
                                                                    decoration: BoxDecoration(
                                                                      color:
                                                                          colorLightGreen,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                            3,
                                                                          ),
                                                                    ),
                                                                    child: Text(
                                                                      'Open Now',
                                                                      style: TextStyle(
                                                                        fontSize:
                                                                            9,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        fontFamily:
                                                                            fontFamilyMain,
                                                                        color:
                                                                            colorTextGreen,
                                                                      ),
                                                                    ),
                                                                  )
                                                                  : Container(
                                                                    padding: EdgeInsets.symmetric(
                                                                      vertical:
                                                                          3,
                                                                      horizontal:
                                                                          7,
                                                                    ),
                                                                    decoration: BoxDecoration(
                                                                      color:
                                                                          colorLightRed,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                            3,
                                                                          ),
                                                                    ),
                                                                    child: Text(
                                                                      'Closed',
                                                                      style: TextStyle(
                                                                        fontSize:
                                                                            9,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        fontFamily:
                                                                            fontFamilyMain,
                                                                        color:
                                                                            colorTextRed,
                                                                      ),
                                                                    ),
                                                                  ),
                                                        ),
                                                        Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                top: 6,
                                                                left: 5,
                                                              ),
                                                          child:
                                                              group.isOpen ==
                                                                      true
                                                                  ? Text(
                                                                    group
                                                                            .end!
                                                                            .isEmpty
                                                                        ? ''
                                                                        : 'Closing at ${group.end}',
                                                                    style: TextStyle(
                                                                      fontSize:
                                                                          9,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontFamily:
                                                                          fontFamilyMain,
                                                                      color:
                                                                          colorDarkGray,
                                                                    ),
                                                                  )
                                                                  : Text(
                                                                    group
                                                                            .start!
                                                                            .isEmpty
                                                                        ? ''
                                                                        : 'Open at ${group.start}',
                                                                    style: TextStyle(
                                                                      fontSize:
                                                                          9,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontFamily:
                                                                          fontFamilyMain,
                                                                      color:
                                                                          colorDarkGray,
                                                                    ),
                                                                  ),
                                                        ),
                                                        Expanded(
                                                          child: Container(
                                                            alignment:
                                                                Alignment
                                                                    .centerRight,
                                                            padding:
                                                                EdgeInsets.only(
                                                                  right: 10,
                                                                ),
                                                            child: InkWell(
                                                              onTap: () {
                                                                // setState(() {
                                                                _favOutletLoadingStates[group
                                                                        .id
                                                                        .toString()] =
                                                                    true;
                                                                // _favOutletLoadingStates[widget
                                                                //         .brandsId] =
                                                                //     true;

                                                                Storage().page =
                                                                    'outletFav_merchant';
                                                                // isClickOutletFav =
                                                                //     true;

                                                                BlocProvider.of<
                                                                  OrderingBloc
                                                                >(context).add(
                                                                  OutletAddRemoveFavouriteLoad(
                                                                    outletId:
                                                                        group.id
                                                                            .toString(),
                                                                    merchantId:
                                                                        widget
                                                                            .brandsId
                                                                            .toString(),
                                                                  ),
                                                                );
                                                                // });
                                                              },
                                                              child: Container(
                                                                padding:
                                                                    EdgeInsets.all(
                                                                      5,
                                                                    ),
                                                                decoration: BoxDecoration(
                                                                  color:
                                                                      colorBackground,
                                                                  shape:
                                                                      BoxShape
                                                                          .circle,
                                                                  border: Border.all(
                                                                    color:
                                                                        colorGreyBorder,
                                                                  ),
                                                                ),
                                                                child:
                                                                    isFavOutletLoading
                                                                        ? Container(
                                                                          padding:
                                                                              EdgeInsets.all(
                                                                                3,
                                                                              ),
                                                                          width:
                                                                              ScreenSize.width *
                                                                              0.053,
                                                                          height:
                                                                              ScreenSize.width *
                                                                              0.053,
                                                                          child: CircularProgressIndicator(
                                                                            color: colorSoftGrey.withValues(
                                                                              alpha:
                                                                                  0.5,
                                                                            ),
                                                                          ),
                                                                        )
                                                                        : group.isFavourite! ==
                                                                            false
                                                                        ? Icon(
                                                                          Icons
                                                                              .favorite_border,
                                                                          size:
                                                                              23,
                                                                          color:
                                                                              colorBlackText,
                                                                        )
                                                                        : Icon(
                                                                          Icons
                                                                              .favorite,
                                                                          size:
                                                                              23,
                                                                          color:
                                                                              colorRaspberyRed,
                                                                        ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Divider(color: colorSocialBoxGrey),
                            ],
                          );
                        },
                      ),
                    )
                    .toList(),
          ),
        );
  }

  Widget _buildAboutUs(BuildContext context, OrderingState state) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    double itemSpacing = width * 0.08;

    if (state is OutletsLoaded) {
      outletInfo = state.outlets;
    }

    return Container(
      margin: EdgeInsets.only(bottom: Platform.isIOS ? 80 : 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(
              marginHorizontal,
              10,
              marginHorizontal,
              10,
            ),
            child: Text(
              outletInfo!.merchant!.name!,
              style: TextStyle(
                fontFamily: fontFamilyMain,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(
              marginHorizontal,
              20,
              marginHorizontal,
              20,
            ),
            child: HtmlWidget(outletInfo!.merchant!.merchantDesc!),
          ),
          outletInfo!.merchant!.socials!.isNotEmpty
              ?
              //  Expanded(
              //     child:
              Container(
                padding: EdgeInsets.fromLTRB(
                  marginHorizontal,
                  20,
                  marginHorizontal,
                  20,
                ),
                // color: colorBabyBlue,
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                      outletInfo!.merchant!.socials!
                          .map(
                            (item) => InkWell(
                              child: Container(
                                // height: height * 0.05,
                                // width: height * 0.05,
                                height: height * 0.045,
                                width: height * 0.045,
                                padding: EdgeInsets.all(
                                  item.type! == 'Website' ? 0 : 5,
                                ),
                                margin: EdgeInsets.only(
                                  right:
                                      outletInfo!.merchant!.socials!.last ==
                                              item
                                          ? 0
                                          : itemSpacing,
                                ),
                                // color: colorBabyBlue,
                                alignment: Alignment.center,
                                child: Image(
                                  image: AssetImage(
                                    item.type! == 'Website'
                                        ? 'assets/icons/social/m_website.webp'
                                        : item.type! == 'Instagram'
                                        ? 'assets/icons/social/m_insta.webp'
                                        : item.type! == 'Facebook'
                                        ? 'assets/icons/social/m_facebook.webp'
                                        : item.type! == 'TikTok'
                                        ? 'assets/icons/social/m_tiktok.webp'
                                        : 'assets/icons/social/m_xhs.webp',
                                  ),
                                ),
                              ),
                              onTap: () async {
                                if (!await launchUrl(
                                  Uri.parse(item.url!),
                                  mode: LaunchMode.externalApplication,
                                )) {
                                  throw 'Could not launch this link';
                                }
                              },
                            ),
                          )
                          .toList(),
                ),
                // ),
              )
              : Container(),
        ],
      ),
      // ),
    );
  }

  Widget _buildVoucherListView(BuildContext context, RewardState state) {
    dynamic voucherTiles;

    if (state is RewardLoading) {
      return Padding(
        padding: EdgeInsets.only(top: ScreenSize.height * 0.2),
        child: LoadingWidget(),
      );
    }

    if (state is RewardMerchantLoaded) {
      // listVoucher = state.rewards;
      listVoucher =
          state.rewards
              .where((voucher) => voucher.purchaseMethod != 'redeemable')
              .toList();
    }

    voucherTiles = listVoucher
        .map((listVoucher) {
          final bool isItemLoading =
              _favouriteLoadingStates[listVoucher.id!] ?? false;

          if (state is RewardAddRemoveFavouriteLoaded) {
            if (listVoucher.id == state.voucherId.toString()) {
              _favouriteLoadingStates.clear();
            }
          }

          return listVoucher.getRewardMerchantTile(
            context: context,
            onTap: () {
              setProcessingStatus(true);

              Navigator.of(context)
                  .pushNamed(
                    OderRoutes.rewardDetails,
                    arguments: RewardDetailsParameters(
                      rewardId: listVoucher.id.toString(),
                      title: Storage().brandName!,
                      indexPage: 3,
                    ),
                  )
                  .then((value) {
                    setProcessingStatus(false);
                  })
                  .then((value) {
                    if (!context.mounted) return;
                    BlocProvider.of<RewardBloc>(
                      context,
                    ).add(RewardMerchantLoad(merchantId: widget.brandsId));
                  });
            },
            onFavouriteTap: () {
              // Set the loading state for THIS specific item to true
              setState(() {
                _favouriteLoadingStates[listVoucher.id!] = true;
              });

              // Dispatch the Bloc event
              Storage().page = 'merchant_wishlist';
              Storage().merchantId = widget.brandsId;

              BlocProvider.of<RewardBloc>(context).add(
                RewardAddRemoveFavouriteLoad(
                  voucherId: listVoucher.id!.toString(),
                  filterBy: '',
                  filterValue: '',
                ),
              );
            },
            isFavClick: isItemLoading,
            // isFavClick: state is FavClick ? true : false,
          );
        })
        .toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        state is RewardEmpty || listVoucher.isEmpty
            ? Center(
              child: Container(
                color: colorBackground,
                height: ScreenSize.height * 0.5,
                // margin: EdgeInsets.symmetric(vertical: 10),
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
                      "No Deals Yet",
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
            )
            : Container(
              color: colorBackground,
              margin: EdgeInsets.only(bottom: Platform.isIOS ? 80 : 30),
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                itemCount: listVoucher.length,
                itemBuilder: (context, index) {
                  return voucherTiles[index];
                },
              ),
            ),
      ],
    );
  }

  Widget _buildGallery(BuildContext context, OrderingState state) {
    if (state is OutletsLoaded) {
      outletInfo = state.outlets;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        outletInfo!.merchant!.menus!.isNotEmpty
            ? Expanded(
              child: Container(
                // height: height,
                // color: colorBabyBlue,
                margin: EdgeInsets.fromLTRB(
                  marginHorizontal,
                  20,
                  marginHorizontal,
                  20,
                ),
                child: GridView.builder(
                  padding: EdgeInsets.zero,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // number of items in each row
                    mainAxisSpacing: 10.0, // spacing between rows
                    crossAxisSpacing: 10.0, // spacing between columns
                    // childAspectRatio: 0.6,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    final String url = outletInfo!.merchant!.menus![index];
                    return GestureDetector(
                      child: AspectRatio(
                        aspectRatio: 1.0,
                        child: Hero(
                          tag: url,
                          child:
                              url == 'This is an video'
                                  ? Container(
                                    alignment: Alignment.center,
                                    child: const Text('This is an video'),
                                  )
                                  : ExtendedImage.network(
                                    url,
                                    fit: BoxFit.cover,
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => SimplePicsWiper(
                                  url: url,
                                  images: outletInfo!.merchant!.menus!,
                                ),
                          ),
                        );
                      },
                    );
                  },
                  itemCount: outletInfo!.merchant!.menus!.length,
                ),
              ),
            )
            : Center(
              child: Container(
                color: colorBackground,
                height: ScreenSize.height * 0.5,
                // margin: EdgeInsets.symmetric(vertical: 10),
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
                            'assets/icons/outlet/no_merchant_gallery.webp',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: ScreenSize.height * 0.03),
                    Text(
                      "No Gallery Yet",
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
            ),
      ],
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

  // Future<void> _saveList(favList) async {
  //   await Storage().secureStorage.write(key: 'favList', value: favList);
  // }

  Future<void> _getList() async {
    final String? favList = await Storage().secureStorage.read(key: 'favList');
    if (favList != null) {
      final List<dynamic> fav = jsonDecode(favList);

      // setState(() {
      outletFav =
          fav.map((item) {
            final Map<String, dynamic> itemMap = item as Map<String, dynamic>;
            return OutletFav.fromJson(itemMap);
          }).toList();
      // });
    }
  }
}

class GroupedItem {
  final String cityState;
  final List<OutletList> outletList;

  GroupedItem(this.cityState, this.outletList);
}

class OutletFav {
  final int id;
  final String merchantName;
  final String image;
  final String place;
  final String distance;

  OutletFav({
    required this.id,
    required this.merchantName,
    required this.image,
    required this.place,
    required this.distance,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "merchantName": merchantName,
      "image": image,
      "place": place,
      "distance": distance,
    };
  }

  factory OutletFav.fromJson(Map<String, dynamic> json) => OutletFav(
    id: json['id'] as int,
    merchantName: json['merchantName'] as String,
    image: json['image'] as String,
    place: json['place'] as String,
    distance: json['distance'] as String,
  );
}
