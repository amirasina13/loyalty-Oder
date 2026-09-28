// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app_setting/app_setting.dart';
import '../../../../data/data.dart';
import '../../../../locator.dart';
import '../../../widgets/widgets.dart';
import '../../../widgets/extensions/ordering_brands_view.dart';
import '../../home/home.dart';
import '../ordering.dart';

class OrderingView extends StatefulWidget {
  final Function changeView;
  final int selectedTab;
  final String? categoryId;

  const OrderingView({
    super.key,
    required this.changeView,
    required this.selectedTab,
    this.categoryId,
  });

  @override
  State<OrderingView> createState() => _OrderingViewState();
}

class _OrderingViewState extends State<OrderingView>
    with TickerProviderStateMixin {
  String idCategory = '';
  late TabController _tabController;
  ScrollController scrollControllerBrands = ScrollController();
  List<dynamic> categoryList = [];
  List<MerchantList> brandsList = [];
  NavigationRailLabelType labelType = NavigationRailLabelType.all;
  bool showLeading = false;
  bool showTrailing = false;
  double groupAlignment = -10.0;
  ValueNotifier<int> selectedCategoryIndex = ValueNotifier<int>(0);
  ValueNotifier<String> selectedCategoryId = ValueNotifier<String>('');
  ValueNotifier<int> selectedTabIndex = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);

    _tabController.addListener(() {
      setState(() {
        // _selectedIndex = _tabController.index;
        _tabController.index;
      });
    });

    categoryList = Storage().globalValue!['brands'];

    idCategory =
        widget.categoryId != null
            ? widget.categoryId!
            : categoryList.first['id'].toString();
    selectedCategoryId.value =
        widget.categoryId != null
            ? widget.categoryId!
            : categoryList.first['id'].toString();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.of(context).pushNamedAndRemoveUntil(
          OderRoutes.home,
          (Route<dynamic> route) => false,
        );
      },

      child: BlocProvider<OrderingBloc>(
        create: (context) {
          return OrderingBloc(orderingRepository: sl())
            ..add(BrandsLoad(categoryId: idCategory, loadingFirst: false));
        },
        child: CustomScrollView(
          physics: NeverScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              forceElevated: true,
              centerTitle: true,
              pinned: true,
              floating: false,
              title: Container(
                width: ScreenSize.width * 0.4,
                color: colorWhite,
                child: Theme(
                  data: ThemeData().copyWith(splashColor: colorWhite),
                  child: TabBar(
                    controller: _tabController,
                    unselectedLabelColor: colorCountGrey,
                    unselectedLabelStyle: TextStyle(
                      fontSize: 13.0,
                      fontFamily: fontFamilyMain,
                      fontWeight: FontWeight.w400,
                    ),
                    labelColor: colorBlack,
                    labelStyle: TextStyle(
                      fontSize: 13.0,
                      fontFamily: fontFamilyMain,
                      fontWeight: FontWeight.w600,
                    ),
                    labelPadding: EdgeInsets.symmetric(horizontal: 5),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    indicatorColor: colorTransparent,
                    dividerColor: colorTransparent,
                    tabs: const [
                      Tab(child: Text("Brand")),
                      Tab(child: Text("Nearby")),
                    ],
                  ),
                ),
              ),
              actions: [
                InkWell(
                  child: Container(
                    width: ScreenSize.width * 0.1,
                    // color: colorBabyBlue,
                    margin: EdgeInsets.only(right: marginHorizontal),
                    padding: EdgeInsets.all(12),
                    child: Image(
                      image: AssetImage('assets/icons/outlet/search.webp'),
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      OderRoutes.searchAPIPage,
                      arguments: SearchScreenParameters(tabFor: 'brand'),
                    );
                  },
                ),
              ],
            ),
            SliverToBoxAdapter(
              // child: Expanded(
              child: Container(
                height: ScreenSize.height - ScreenSize.heightAppbar,
                color: colorBackground,
                child: TabBarView(
                  controller: _tabController,
                  // physics: NeverScrollableScrollPhysics(),
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Left side: Drawer for Categories
                        Container(
                          margin: EdgeInsets.only(right: 5, bottom: 0),
                          padding: EdgeInsets.only(
                            bottom: Platform.isIOS ? 70 : 50,
                          ),
                          width: ScreenSize.width * 0.26,
                          height: ScreenSize.height,
                          decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                color: colorLightGray,
                                width: 1.0,
                              ),
                            ),
                          ),
                          child: Drawer(
                            backgroundColor: colorBackground,
                            shadowColor: colorBackground,
                            elevation: 0,
                            child: ListView.builder(
                              padding: EdgeInsets.only(
                                top: 10,
                                bottom:
                                    Platform.isIOS
                                        ? ScreenSize.height * 0.13
                                        : ScreenSize.height * 0.13,
                              ),
                              itemCount: categoryList.length,
                              // physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                var category = categoryList[index];

                                return ValueListenableBuilder<String>(
                                  valueListenable: selectedCategoryId,
                                  builder: (context, currentSelectedId, child) {
                                    return Stack(
                                      children: [
                                        ListTile(
                                          dense: true,
                                          contentPadding: EdgeInsets.zero,
                                          splashColor: colorTransparent,
                                          title: SizedBox(
                                            height: ScreenSize.height * 0.07,
                                            width: ScreenSize.width,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image(
                                                  height:
                                                      ScreenSize.height * 0.04,
                                                  fit: BoxFit.contain,
                                                  image:
                                                      Image.memory(
                                                        base64.decode(
                                                          category['image']
                                                              .replaceAll(
                                                                RegExp(
                                                                  r'^data:image\/[a-z]+;base64,',
                                                                ),
                                                                '',
                                                              ),
                                                        ),
                                                      ).image,
                                                  // color:
                                                  //     selectedCategoryId
                                                  //                 .value ==
                                                  //             categoryList[index]['id']
                                                  //         ? colorMulberry
                                                  //         : colorCountGrey,
                                                  // colorBlendMode:
                                                  //     BlendMode.srcATop,
                                                ),
                                                SizedBox(height: 5),
                                                Text(
                                                  category['name'],
                                                  style: TextStyle(
                                                    fontSize: 9,
                                                    color:
                                                        selectedCategoryId
                                                                    .value ==
                                                                categoryList[index]['id']
                                                            ? colorMulberry
                                                            : colorTextGrey,
                                                    fontWeight:
                                                        selectedCategoryId
                                                                    .value ==
                                                                categoryList[index]['id']
                                                            ? FontWeight.bold
                                                            : FontWeight.normal,
                                                  ),

                                                  maxLines: 2,
                                                  textAlign: TextAlign.center,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),

                                                // Divider(), // Optional: Add a divider between categories
                                              ],
                                            ),
                                          ),
                                          onTap: () {
                                            if (currentSelectedId ==
                                                category['id']) {
                                              return;
                                            }

                                            selectedCategoryIndex.value = index;
                                            selectedCategoryId.value =
                                                categoryList[index]['id']
                                                    .toString();
                                            context.read<OrderingBloc>().add(
                                              BrandsLoad(
                                                categoryId:
                                                    categoryList[index]['id']
                                                        .toString(),
                                                loadingFirst: false,
                                              ),
                                            );
                                          },
                                        ),

                                        // Animated position indicator
                                        if (currentSelectedId ==
                                            category['id'].toString())
                                          Positioned(
                                            top: 0,
                                            right: 0,
                                            child: Container(
                                              height: ScreenSize.height * 0.078,
                                              width: 4,
                                              decoration: const BoxDecoration(
                                                color: colorGoldButton,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(5),
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                        // Right side: Brands View
                        BlocBuilder<OrderingBloc, OrderingState>(
                          builder: (context, state) {
                            return Expanded(
                              child: Container(
                                height: ScreenSize.height * 0.8,
                                margin: EdgeInsets.only(bottom: 20),
                                padding: EdgeInsets.only(
                                  bottom: Platform.isIOS ? 30 : 0,
                                ),
                                color: colorBackground,
                                child: ValueListenableBuilder(
                                  valueListenable: selectedCategoryId,
                                  builder: (context, value, child) {
                                    if (state is BrandsLoading ||
                                        (state is BrandsLoaded &&
                                            selectedCategoryId.value !=
                                                value)) {
                                      return Center(
                                        child: LoadingWidget(),
                                      ); // Your loadingWidget
                                    }
                                    return _buildBrandList(context, state);
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    OrderingNearbyScreen(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrandList(BuildContext context, OrderingState state) {
    if (state is OrderingEmpty) {
      return Center(
        child: Container(
          color: colorBackground,
          margin: EdgeInsets.only(bottom: ScreenSize.height * 0.15),
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
                "No Available Brands",
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

    // if (state is BrandsLoading) {
    //   return Container(
    //     margin: EdgeInsets.only(bottom: ScreenSize.height * 0.15),
    //     color: colorBackground,
    //     child: LoadingWidget(),
    //   );
    // }

    if (state is BrandsLoaded) {
      brandsList = state.merchants;
    }

    if (brandsList.isEmpty) {
      return Container(
        margin: EdgeInsets.only(bottom: ScreenSize.height * 0.15),
        color: colorBackground,
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
              "No Available Brands",
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

    // // if (nearbyOutlet != null) {
    var brandsListTiles = brandsList
        .map(
          (brandsList) => brandsList.getListBrandTile(
            context: context,
            // state: state,
            onTap: () {
              // Storage().brandId = brandsList.id!;
              Storage().brandName = brandsList.name;
              Navigator.of(context)
                  .pushNamed(
                    OderRoutes.orderingOutlet,
                    arguments: OrderingOutletParameters(
                      brandsId: brandsList.id.toString(),
                    ),
                  )
                  .then((value) {});
            },
          ),
        )
        .toList(growable: false);

    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.only(top: 10, bottom: ScreenSize.height * 0.18),
      itemCount: brandsList.length,
      // physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.9,
        mainAxisSpacing: 15,
        // crossAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        return brandsListTiles[index];
      },
    );
  }
}
