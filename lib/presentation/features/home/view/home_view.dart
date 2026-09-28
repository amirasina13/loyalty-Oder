// ignore_for_file: unused_field

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../app_setting/app_setting.dart';
import '../../../../data/data.dart';
import '../../../../util/utils.dart';
import '../../../widgets/widgets.dart';
import '../../bulletin/bulletin.dart';
import '../../ordering/ordering.dart';
import '../../rewards/reward.dart';
import '../../voucher/voucher.dart';
import '../../webview/webview_deeplink.dart';
import '../home.dart';

class HomeViewNew extends StatefulWidget {
  final String? token;
  final Function changeView;

  const HomeViewNew({super.key, this.token, required this.changeView});

  @override
  State<HomeViewNew> createState() => _HomeViewNewState();
}

class _HomeViewNewState extends State<HomeViewNew> {
  List<Slideshow> slideshowImage = [];
  List<CategoryVoucher> categories = [];
  List<VouchersCat> catVouchers = [];
  List<Upcoming> upcoming = [];
  List<Merchant> merchants = [];
  List<Highlight> highlight = [];
  List<MiniProgram> miniProgram = [];
  int _current = 0;
  String announcement = '';
  bool isClose = false;
  final bool _enabled = true;
  // final CarouselController _controller = CarouselController();
  CarouselSliderController carouselController = CarouselSliderController();

  var top = 0.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is HomeLoaded) {
          slideshowImage = state.homePage.slideshow!;
          categories = state.homePage.categories!;
          upcoming = state.homePage.upcoming!;
          merchants = state.homePage.merchants!;
          highlight = state.homePage.highlight!;
          miniProgram = state.homePage.mini!;
          announcement = state.homePage.announcements!;

          return CustomScrollView(
            slivers: [
              // ----------------------------------------------------------------- Dynamic appbar
              SliverAppBar(
                expandedHeight: ScreenSize.height * 0.25,
                collapsedHeight: ScreenSize.height * 0.17,
                floating: true,
                pinned: true,
                snap: true,
                elevation: 0,
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor:
                      colorTransparent, // this one will make the statusbar transparent
                  statusBarIconBrightness:
                      Brightness.light, //this will take care of the icon color
                ),
                flexibleSpace: Stack(
                  children: <Widget>[
                    // ----------------------------------------------------------- Slideshow image
                    Positioned.fill(
                      child: Padding(
                        padding: EdgeInsets.only(
                          bottom: 24,
                          top: MediaQuery.of(context).padding.top,
                          // top: ScreenSize.height * 0.02,
                        ),
                        child: _buildslideshowImage(context, state),
                      ),
                    ),
                    // ----------------------------------------------------------- Search box
                    Container(
                      alignment: Alignment.bottomCenter,
                      child: _searchBar(true),
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    // ----------------------------------------------------------- Category button (Top Brands/ trending Voucher)
                    _buildCategory(),
                    announcement.isNotEmpty && isClose == false
                        ? _announcementWidget(announcement)
                        : Container(),
                    // ----------------------------------------------------------- Upcoming Event
                    _buildUpcomingEvent(state),
                    // ----------------------------------------------------------- Merchant/ Brand
                    _buildTopBrand(state),
                  ],
                ),
              ),
              // ----------------------------------------------------------------- Category voucher(Trending voucher/ hot deals voucher)
              SliverList(
                delegate: SliverChildBuilderDelegate((
                  BuildContext context,
                  int index,
                ) {
                  return _buildCategoryVoucher(index);
                }, childCount: categories.length),
              ),
              // ----------------------------------------------------------------- Highlight/ bulletin list
              SliverToBoxAdapter(child: _buildHighlight()),
              SliverToBoxAdapter(
                child: SizedBox(height: ScreenSize.height * 0.02),
              ),
            ],
          );
        }

        return _homeLoading();
      },
    );
  }

  Widget _homeLoading() {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Container(
        height: ScreenSize.height,
        color: colorTransparent,
        child: Shimmer.fromColors(
          baseColor: colorLightGray,
          highlightColor: colorWhiteQrLight,
          enabled: _enabled,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: ScreenSize.height * 0.31,
                  color: colorWhite,
                  padding: EdgeInsets.fromLTRB(
                    marginHorizontal,
                    50,
                    marginHorizontal,
                    10,
                  ),
                ),
                Container(
                  height: ScreenSize.height * 0.1,
                  // color: colorWhite,
                  margin: EdgeInsets.fromLTRB(
                    marginHorizontal,
                    8,
                    marginHorizontal,
                    20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (int i = 0; i < 5; i++)
                        Container(
                          height: ScreenSize.height * 0.07,
                          width: ScreenSize.height * 0.07,
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colorWhite,
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: ScreenSize.height * 0.03),
                Container(
                  height: ScreenSize.height * 0.03,
                  width: ScreenSize.width,
                  padding: EdgeInsets.symmetric(vertical: 23),
                  margin: EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: marginHorizontal,
                  ),
                  color: colorWhite,
                ),
                Container(
                  height: ScreenSize.height * 0.15,
                  width: ScreenSize.width,
                  margin: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: marginHorizontal,
                  ),
                  color: colorWhite,
                ),
                SizedBox(height: ScreenSize.height * 0.04),
                Container(
                  height: ScreenSize.height * 0.03,
                  width: ScreenSize.width,
                  padding: EdgeInsets.symmetric(vertical: 23),
                  margin: EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: marginHorizontal,
                  ),
                  color: colorWhite,
                ),
                Container(
                  height: ScreenSize.height * 0.15,
                  width: ScreenSize.width,
                  margin: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: marginHorizontal,
                  ),
                  color: colorWhite,
                ),
                SizedBox(height: ScreenSize.height * 0.04),
                Container(
                  height: ScreenSize.height * 0.03,
                  width: ScreenSize.width,
                  padding: EdgeInsets.symmetric(vertical: 23),
                  margin: EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: marginHorizontal,
                  ),
                  color: colorWhite,
                ),
                Container(
                  height: ScreenSize.height * 0.15,
                  width: ScreenSize.width,
                  margin: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: marginHorizontal,
                  ),
                  color: colorWhite,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Slideshow image body
  Widget _buildslideshowImage(BuildContext context, HomeState state) {
    // If slideshow empty, return container
    if (slideshowImage.isEmpty) {
      return AspectRatio(
        aspectRatio: 2 / 1,
        child: Container(
          height: ScreenSize.height * 0.23,
          color: colorBackground,
        ),
      );
    }

    // Else, return Carousel image
    return CarouselSlider(
      items:
          slideshowImage.map((item) {
            // Fallback safely if path or url are empty
            final String imagePath =
                item.path?.isNotEmpty == true ? item.path! : (item.url ?? '');

            if (imagePath.isEmpty) {
              return Container(color: colorBackground);
            }

            return CachedNetworkImage(
              imageUrl: imagePath,
              imageBuilder: (context, imageProvider) {
                return Container(
                  width: ScreenSize.width,
                  // alignment: Alignment.center, // where to position the child
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(item.path!),
                    ),
                  ),
                );
              },
            );
          }).toList(),
      carouselController: carouselController,
      options: CarouselOptions(
        // height: ScreenSize.height * 0.25,
        padEnds: false,
        viewportFraction: 1.0,
        enableInfiniteScroll: false,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 5),
        onPageChanged: (index, reason) {
          setState(() {
            _current = index;
          });
        },
      ),
    );
  }

  // search box body
  Widget _searchBar(bool? showSuffix) {
    var width = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () {
        // Navigator.of(context).pushNamed(OderRoutes.searchResultsPage);
        Navigator.of(context).pushNamed(
          OderRoutes.searchAPIPage,
          arguments: SearchScreenParameters(tabFor: 'home'),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: marginHorizontal),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        decoration: BoxDecoration(
          color: colorWhite,
          border: Border.all(color: colorGreyBox),
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8.0,
              offset: Offset(0.0, 3.0),
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(
              width: width * 0.05,
              child: Image(
                image: AssetImage('assets/icons/outlet/search.webp'),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                'Search',
                style: TextStyle(
                  color: colorSoftGrey,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  fontFamily: fontFamilyMain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategory() {
    // double itemSpacing =
    //     Platform.isIOS ? ScreenSize.width * 0.04 : ScreenSize.width * 0.045;
    int totalLength = 4;
    int lengthBlnce = 0;
    lengthBlnce = totalLength - categories.length;

    // Build list of items dynamically first
    List<Widget> items = [];

    // Top Brands
    items.add(_buildTopBrandsItem());

    // Dynamic Categories (up to 3)
    for (int i = 0; i < (categories.length > 3 ? 3 : categories.length); i++) {
      items.add(_buildCategoryItem(categories[i]));
    }

    // Mini Programs & View All
    if (miniProgram.isNotEmpty) {
      if (totalLength == 1) {
        items.add(_buildViewAllItem());
      } else if (miniProgram.length < lengthBlnce) {
        for (int j = 0; j < miniProgram.length; j++) {
          items.add(_buildMiniProgramItem(miniProgram[j]));
        }
      } else {
        for (int j = 0; j < lengthBlnce - 1; j++) {
          items.add(_buildMiniProgramItem(miniProgram[j]));
        }
        items.add(_buildViewAllItem());
      }
    }

    return Container(
      height: ScreenSize.height * 0.12,
      margin: EdgeInsets.fromLTRB(marginHorizontal, 20, marginHorizontal, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < 5; i++)
            Expanded(
              child: Align(
                alignment: Alignment.topLeft,
                child: Center(
                  child: i < items.length ? items[i] : const SizedBox(),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTopBrandsItem() {
    return InkWell(
      splashColor: colorTransparent,
      highlightColor: colorTransparent,
      onTap: () {
        Navigator.of(context).pushNamedAndRemoveUntil(
          OderRoutes.orderingMerchant,
          (Route<dynamic> route) => false,
          arguments: OrderingScreenParameters(selectedTab: 1),
        );
      },
      child: Column(
        children: [
          Container(
            height: ScreenSize.height * 0.065,
            width: ScreenSize.height * 0.065,
            // padding: EdgeInsets.fromLTRB(0, 5, 5, 5),
            padding: const EdgeInsets.all(5),
            child: const Image(
              image: AssetImage('assets/icons/homePage/top.webp'),
            ),
          ),
          Container(
            width: ScreenSize.height * 0.065,
            padding: EdgeInsets.only(top: 5),
            child: const Text(
              'Top Brands',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colorBlack,
                fontSize: 10,
                fontWeight: FontWeight.w300,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(dynamic category) {
    return InkWell(
      splashColor: colorTransparent,
      highlightColor: colorTransparent,
      onTap: () {
        Storage().isTabChange = false;
        Navigator.of(context).pushNamedAndRemoveUntil(
          OderRoutes.voucher,
          (Route<dynamic> route) => false,
          arguments: VoucherParameters(
            selectedTab: 0,
            filterBy: category.filterBy!,
            filterValue: category.id!.toString(),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: ScreenSize.height * 0.065,
            width: ScreenSize.height * 0.065,
            padding: const EdgeInsets.all(5),
            child: Image(image: NetworkImage(category.image!)),
          ),
          Container(
            width: ScreenSize.height * 0.065,
            padding: EdgeInsets.only(top: 5),
            child: Text(
              category.name!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: colorBlack,
                fontSize: 10,
                fontWeight: FontWeight.w300,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniProgramItem(dynamic item) {
    return InkWell(
      splashColor: colorTransparent,
      highlightColor: colorTransparent,
      onTap: () {
        if (item.url != null) {
          Navigator.push(
            context,
            NoAnimationPageRoute(
              builder:
                  (context) => WidgetWebView(
                    widgetUrl: item.url!,
                    title: item.name ?? '',
                  ),
            ),
          );
        } else {
          showErrorToast('Not available', context);
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: ScreenSize.height * 0.065,
            width: ScreenSize.height * 0.065,
            padding: const EdgeInsets.all(5),
            child: Image(image: NetworkImage(item.image!)),
          ),
          Container(
            width: ScreenSize.height * 0.065,
            padding: EdgeInsets.only(top: 5),
            child: Text(
              item.name!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: colorBlack,
                fontSize: 10,
                fontWeight: FontWeight.w300,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewAllItem() {
    return InkWell(
      splashColor: colorTransparent,
      highlightColor: colorTransparent,
      onTap: () => modalBottomSheetMenu(),
      child: Column(
        children: [
          Container(
            height: ScreenSize.height * 0.065,
            width: ScreenSize.height * 0.065,
            padding: const EdgeInsets.all(5),
            child: Container(
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorGoldButton,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    offset: const Offset(0, 2),
                    blurRadius: 5,
                  ),
                ],
              ),
              child: const ClipOval(
                child: Image(
                  image: AssetImage('assets/icons/homePage/viewall.png'),
                ),
              ),
            ),
          ),
          SizedBox(
            width: ScreenSize.height * 0.065,
            child: const Text(
              'View All',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colorBlack,
                fontSize: 10,
                fontWeight: FontWeight.w300,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _announcementWidget(String announcement) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return SizedBox(
      height: height * 0.06,
      // width: width,
      // color: colorBackground,
      // margin: EdgeInsets.only(top: 15),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: marginHorizontal),
        // padding: EdgeInsets.symmetric(horizontal: 10),
        child: Card(
          elevation: 2,
          color: colorGoldButton,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: width * 0.05,
                margin: EdgeInsets.symmetric(horizontal: 10),
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Image(
                  image: AssetImage('assets/icons/homePage/announcement.png'),
                ),
              ),
              Expanded(
                child: SizedBox(
                  // width: width * 0.6,
                  // color: secondaryColor,
                  child: ScrollingText(
                    text: announcement,
                    textStyle: TextStyle(fontSize: 12),
                  ),
                ),
              ),
              Container(
                // width: width * 0.06,
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: InkWell(
                  highlightColor: colorTransparent,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colorWhite,
                    ),
                    child: Icon(Icons.close, size: 20),
                  ),
                  onTap: () {
                    setState(() {
                      isClose = true;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Upcoming event body
  Widget _buildUpcomingEvent(HomeState state) {
    if (upcoming.isEmpty) {
      return Container();
    }

    /* IF API call success and not empty, show listView If Perks section*/
    return Container(
      color: colorBackground,
      height: ScreenSize.height * 0.2,
      padding: EdgeInsets.fromLTRB(marginHorizontal, 5, marginHorizontal, 0),
      child: Column(
        children: [
          Container(
            width: ScreenSize.width,
            color: colorBackground,
            margin: EdgeInsets.only(top: 7, bottom: 7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(right: 5),
                      child: Image(
                        height: ScreenSize.height * 0.03,
                        image: AssetImage('assets/icons/homePage/event.webp'),
                      ),
                    ),
                    Text(
                      'Upcoming Events',
                      style: TextStyle(
                        fontFamily: fontFamilyMain,
                        fontSize: 21,
                        fontWeight: FontWeight.w300,
                        color: colorRedLight,
                      ),
                      textScaler: TextScaler.linear(scaleFactor),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(OderRoutes.upcoming);
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colorGoldButton.withValues(alpha: 0.2),
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 15,
                        color: colorRedDark,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: upcoming.length,
              // physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      OderRoutes.bulletinDetails,
                      arguments: BulletinDetailsParameters(
                        bulletinId: upcoming[index].id.toString(),
                        title: upcoming[index].name!,
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                      right: index == upcoming.length - 1 ? 0 : 3,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: ScreenSize.width * 0.28,
                          color: colorBackground,
                          child: AspectRatio(
                            aspectRatio: 1 / 1,
                            // child: InkWell(
                            child: Container(
                              decoration: BoxDecoration(
                                // border: Border.all(
                                //   color: colorGreyBox,
                                // ),
                                // borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: NetworkImage(upcoming[index].image!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            // ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Merchant body
  Widget _buildTopBrand(HomeState state) {
    if (merchants.isEmpty) {
      return Container();
    }

    /* IF API call success and not empty, show listView If Perks section*/
    return Container(
      color: colorBackground,
      height:
          Platform.isAndroid
              ? ScreenSize.height * 0.23
              : ScreenSize.height * 0.24,
      padding: EdgeInsets.fromLTRB(marginHorizontal, 5, marginHorizontal, 0),
      //============================================== need cange to listview
      child: Column(
        children: [
          Container(
            width: ScreenSize.width,
            color: colorBackground,
            margin: EdgeInsets.only(top: 7, bottom: 7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(right: 5),
                      child: Image(
                        height: ScreenSize.height * 0.03,
                        image: AssetImage('assets/icons/homePage/top.webp'),
                      ),
                    ),
                    Text(
                      'Top Brand',
                      style: TextStyle(
                        fontFamily: fontFamilyMain,
                        fontSize: 21,
                        fontWeight: FontWeight.w300,
                        color: colorRedLight,
                      ),
                      textScaler: TextScaler.linear(scaleFactor),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        OderRoutes.orderingMerchant,
                        (Route<dynamic> route) => false,
                        arguments: OrderingScreenParameters(selectedTab: 1),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colorGoldButton.withValues(alpha: 0.2),
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 15,
                        color: colorRedDark,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: merchants.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Storage().brandName = merchants[index].name;
                    Navigator.of(context)
                        .pushNamed(
                          OderRoutes.orderingOutlet,
                          arguments: OrderingOutletParameters(
                            brandsId: merchants[index].id.toString(),
                          ),
                        )
                        .then((value) {});
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                      right: index == merchants.length - 1 ? 0 : 7,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: ScreenSize.width * 0.28,
                          color: colorBackground,
                          child: AspectRatio(
                            aspectRatio: 1 / 1,
                            // child: InkWell(
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: colorGreyBox),
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        merchants[index].image!,
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                merchants[index].isMuslim == true
                                    ? Positioned(
                                      right: 5,
                                      top: 5,
                                      child: HalalWidget(
                                        muslimCategory:
                                            merchants[index].muslimCategory!,
                                        width: ScreenSize.width * 0.08,
                                      ),
                                    )
                                    : SizedBox(),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: ScreenSize.width * 0.25,
                          padding: EdgeInsets.only(top: 5),
                          child: Text(
                            merchants[index].name!,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              fontFamily: fontFamilyMain,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Categry voucher body
  Widget _buildCategoryVoucher(index) {
    catVouchers = categories[index].vouchers!;

    if (catVouchers.isEmpty) {
      return Container();
    }

    /* IF API call success and not empty, show listView If Perks section*/
    return Container(
      height:
          Platform.isAndroid
              ? ScreenSize.height * 0.23
              : ScreenSize.height * 0.24,
      padding: EdgeInsets.fromLTRB(marginHorizontal, 5, marginHorizontal, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: ScreenSize.width,
            color: colorBackground,
            margin: EdgeInsets.only(top: 7, bottom: 7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(right: 5),
                      child: Image(
                        height: ScreenSize.height * 0.03,
                        image: NetworkImage(categories[index].image!),
                      ),
                    ),
                    Text(
                      categories[index].name!,
                      style: TextStyle(
                        fontFamily: fontFamilyMain,
                        fontSize: 21,
                        fontWeight: FontWeight.w300,
                        color: colorRedLight,
                      ),
                      textScaler: TextScaler.linear(scaleFactor),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: InkWell(
                    onTap: () {
                      Storage().isTabChange = false;
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        OderRoutes.voucher,
                        (Route<dynamic> route) => false,
                        arguments: VoucherParameters(
                          selectedTab: 0,
                          filterBy: categories[index].filterBy!,
                          filterValue: categories[index].id!.toString(),
                        ),
                      );
                      //   OderRoutes.voucher, (Route<dynamic> route) => true,
                      // arguments: VoucherParameters(
                      //   selectedTab: 0,
                      //   filterBy: 'all',
                      //   filterValue: '1',
                      // )
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colorGoldButton.withValues(alpha: 0.2),
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 15,
                        color: colorRedDark,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: _buildVoucher(context, categories[index].vouchers!)),
        ],
      ),
    );
  }

  Widget _buildVoucher(BuildContext context, List<VouchersCat> catVoucher) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeProcessing) {
          return Center(
            child: CircularProgressIndicator(color: colorDisableGrey),
          );
        }

        return ListView.builder(
          itemCount: catVoucher.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, indexCat) {
            return InkWell(
              onTap: () {
                TempData.voucherRefCode = '';
                Navigator.of(context).pushNamed(
                  OderRoutes.rewardDetails,
                  arguments: RewardDetailsParameters(
                    rewardId: catVoucher[indexCat].id.toString(),
                    title: catVoucher[indexCat].name!,
                    indexPage: 3,
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.only(
                  right: indexCat == catVoucher.length - 1 ? 0 : 7,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: ScreenSize.width * 0.28,
                      color: colorBackground,
                      child: AspectRatio(
                        aspectRatio: 1 / 1,
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: colorGreyBox),
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    catVoucher[indexCat].image!,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            catVoucher[indexCat].isMuslim == true
                                ? Positioned(
                                  right: 3,
                                  top: 5,
                                  child: HalalWidget(
                                    muslimCategory:
                                        catVoucher[indexCat].muslimCategory!,
                                    width: ScreenSize.width * 0.08,
                                  ),
                                )
                                : SizedBox(),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: ScreenSize.width * 0.25,
                      padding: EdgeInsets.only(top: 5),
                      child: Text(
                        catVoucher[indexCat].name!,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontFamily: fontFamilyMain,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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

  // Highlight/ bulletin body
  Widget _buildHighlight() {
    if (highlight.isEmpty) {
      return Container();
    }

    /* IF API call success and not empty, show listView If Perks section*/
    return Container(
      height: ScreenSize.height * 0.23,
      padding: EdgeInsets.fromLTRB(marginHorizontal, 5, marginHorizontal, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: ScreenSize.width,
            color: colorBackground,
            margin: EdgeInsets.only(top: 7, bottom: 7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(right: 5),
                      child: Image(
                        height: ScreenSize.height * 0.03,
                        image: AssetImage(
                          'assets/icons/homePage/highlight.webp',
                        ),
                      ),
                    ),
                    Text(
                      'Highlight',
                      style: TextStyle(
                        fontFamily: fontFamilyMain,
                        fontSize: 21,
                        fontWeight: FontWeight.w300,
                        color: colorRedLight,
                      ),
                      textScaler: TextScaler.linear(scaleFactor),
                    ),
                  ],
                ),
                Container(
                  // color: colorBabyBlue,
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(OderRoutes.bulletin);
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colorGoldButton.withValues(alpha: 0.2),
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 15,
                        color: colorRedDark,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              // shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: highlight.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      OderRoutes.bulletinDetails,
                      arguments: BulletinDetailsParameters(
                        bulletinId: highlight[index].id.toString(),
                        title: highlight[index].name!,
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                      right: index == upcoming.length - 1 ? 0 : 7,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: ScreenSize.width * 0.3,
                          color: colorBackground,
                          child: AspectRatio(
                            aspectRatio: 2 / 1,
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: colorGreyBox),
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        highlight[index].image!,
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: ScreenSize.width * 0.25,
                          padding: EdgeInsets.only(top: 5),
                          child: Text(
                            highlight[index].name!,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              fontFamily: fontFamilyMain,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // View all bottom body
  // View all bottom body
  void modalBottomSheetMenu() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
      ),
      backgroundColor: colorBackground,
      builder: (builder) {
        return Container(
          height: ScreenSize.height * 0.4,
          padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
          child: CustomScrollView(
            primary: false,
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: marginHorizontal,
                  ),
                  child: Text(
                    'Recommended',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: colorRedLight,
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  marginHorizontal,
                  10,
                  marginHorizontal,
                  0,
                ),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    // crossAxisSpacing: 1.0,
                    mainAxisSpacing: ScreenSize.height * 0.02,
                    mainAxisExtent: ScreenSize.width * 0.27,
                  ),
                  delegate: SliverChildBuilderDelegate((
                    BuildContext context,
                    int i,
                  ) {
                    if (i == 0) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            OderRoutes.orderingMerchant,
                            (Route<dynamic> route) => false,
                            arguments: OrderingScreenParameters(selectedTab: 1),
                          );
                        },
                        child: Column(
                          children: [
                            Container(
                              height: ScreenSize.height * 0.07,
                              width: ScreenSize.height * 0.07,
                              padding: EdgeInsets.all(5),
                              // margin: EdgeInsets.only(right: 7),
                              child: Image(
                                image: AssetImage(
                                  'assets/icons/homePage/top.webp',
                                ),
                              ),
                            ),
                            Container(
                              width: ScreenSize.height * 0.07,
                              padding: EdgeInsets.only(top: 5),
                              child: Text(
                                'Top Brands',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: colorBlack,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w300,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    int categoryIndex = i - 1;

                    return InkWell(
                      onTap: () {
                        Storage().isTabChange = false;
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          OderRoutes.voucher,
                          (Route<dynamic> route) => false,
                          arguments: VoucherParameters(
                            selectedTab: 0,
                            filterBy: categories[categoryIndex].filterBy!,
                            filterValue:
                                categories[categoryIndex].id!.toString(),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: ScreenSize.height * 0.07,
                            width: ScreenSize.height * 0.07,
                            padding: EdgeInsets.all(5),
                            child: Image(
                              image: NetworkImage(
                                categories[categoryIndex].image!,
                              ),
                            ),
                          ),
                          Container(
                            width: ScreenSize.height * 0.07,
                            padding: EdgeInsets.only(top: 5),
                            child: Text(
                              categories[categoryIndex].name!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: colorBlack,
                                fontSize: 10,
                                fontWeight: FontWeight.w300,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  }, childCount: categories.length + 1),
                ),
              ),
              SliverToBoxAdapter(
                child:
                    miniProgram.isNotEmpty
                        ? Container(
                          margin: EdgeInsets.only(top: 20),
                          padding: const EdgeInsets.symmetric(
                            horizontal: marginHorizontal,
                          ),
                          child: Text(
                            'Service',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: colorRedLight,
                            ),
                          ),
                        )
                        : Container(),
              ),
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  marginHorizontal,
                  10,
                  marginHorizontal,
                  0,
                ),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    // crossAxisSpacing: 1.0,
                    mainAxisSpacing: ScreenSize.height * 0.02,
                    mainAxisExtent: ScreenSize.width * 0.28,
                  ),
                  delegate: SliverChildBuilderDelegate((
                    BuildContext context,
                    int i,
                  ) {
                    return InkWell(
                      onTap: () {
                        if (miniProgram[i].url != null) {
                          Navigator.push(
                            context,
                            NoAnimationPageRoute(
                              builder: (context) {
                                // Directly return WidgetWebView, as it contains its own Scaffold and AppBar
                                return WidgetWebView(
                                  widgetUrl: miniProgram[i].url!,
                                  title: miniProgram[i].name!,
                                );
                              },
                            ),
                          );
                        } else {
                          showErrorToast('Not available', context);
                        }
                      },
                      child: Column(
                        children: [
                          Container(
                            height: ScreenSize.height * 0.07,
                            width: ScreenSize.height * 0.07,
                            padding: EdgeInsets.all(5),
                            // margin: EdgeInsets.only(right: 10),
                            child: Image(
                              image: NetworkImage(miniProgram[i].image!),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              width: ScreenSize.height * 0.07,
                              padding: EdgeInsets.only(top: 5),
                              // margin: EdgeInsets.only(right: 10),
                              child: Text(
                                miniProgram[i].name!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: colorBlack,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w300,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }, childCount: miniProgram.length),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
