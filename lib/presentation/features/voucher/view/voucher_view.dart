import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

import '../../../../app_setting/app_setting.dart';
import '../../../../data/data.dart';
import '../../../../locator.dart';
import '../../../widgets/widgets.dart';
import '../../authentication/authentication.dart';
import '../../home/home.dart';
import '../../rewards/reward.dart';
import '../voucher.dart';

class VoucherView extends StatefulWidget {
  final Function changeView;
  final int selectedTab;
  final String filterBy;
  final String filterValue;

  const VoucherView({
    super.key,
    required this.changeView,
    required this.selectedTab,
    required this.filterBy,
    required this.filterValue,
  });

  @override
  State<VoucherView> createState() => _VoucherViewState();
}

class _VoucherViewState extends State<VoucherView>
    with SingleTickerProviderStateMixin {
  /* --------------------------------------------------------------------------- set variable */

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<VoucherRewardsTabState> genarateWidgetKey =
      GlobalKey<VoucherRewardsTabState>();

  late TabController _tabController;
  late ScrollController _scrollController;
  String barcodeScanRes = '';
  late Timer durationLoading;
  bool isProcessing = false;
  String? categoryName;
  var formatter = DateFormat(appDateFormat);
  FilterData? filterData;
  bool isSelected = false;
  // int? selectedCategory;
  String updatedFilterBy = '', updatedFilterValue = '';
  bool tabChange = false;

  /* ------------------------------------------------------------------------ */

  MerchantCategory? merchantCategory;
  bool isRefresh = false;
  // late String filterState;
  FilterData? filterState;
  RewardState? updatedState;
  Color buttonColor = colorBlack;
  RewardState? updateEmptyReward;

  void setProcessingStatus(bool processing) {
    setState(() {
      isProcessing = processing;
    });
  }

  void onSelectionChange(String filterBy, String filterValue) {
    setState(() {
      updatedFilterBy = filterBy;
      updatedFilterValue = filterValue;
    });
  }

  /* --------------------------------------------------------------------------- initState - Called when this object is inserted into the tree */
  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.selectedTab,
    );

    categoryName = 'All';

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {});
      }
    });

    fToast = FToast();
    fToast.init(context);

    updatedFilterBy = widget.filterBy;
    updatedFilterValue = widget.filterValue;
  }

  /* --------------------------------------------------------------------------- dispose - Called when this object is removed from the tree permanently. */
  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  // Helper to build custom tab items
  Widget _buildTabItem(String label, int index) {
    bool isSelected = _tabController.index == index;
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: isSelected ? colorMulberry : colorWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? colorMulberry : colorWhiteLight,
          width: 1,
        ),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(color: isSelected ? colorWhite : colorBlack),
        ),
      ),
    );
  }

  /* --------------------------------------------------------------------------- Full body */
  @override
  Widget build(BuildContext context) {
    /* ------------------------------------------------------------------------- Scaffold */
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.of(context).pushNamedAndRemoveUntil(
          OderRoutes.home,
          (Route<dynamic> route) => false,
        );
      },
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: OderScaffold(
          scaffoldKey: _scaffoldKey,
          showAppbar: false,
          bottomMenuIndex: 2,
          isShow: true,
          canClick: false,

          /* ----------------------------------------------------------------------- Main body */
          body: Column(
            children: [
              _buildHeader(),
              _buildTabBarSection(),
              // Use Expanded instead of fixed height Container for responsiveness
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    BlocProvider<RewardBloc>(
                      create:
                          (context) => RewardBloc(
                            context: context,
                            rewardRepository: sl(),
                          ),
                      child: VoucherRewardsTab(
                        filterBy: updatedFilterBy,
                        filterValue: updatedFilterValue,
                      ),
                    ),
                    const MyVoucherTab(),
                    const MyVoucherPastTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(marginHorizontal, 60, marginHorizontal, 10),
      color: colorBackground,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: ScreenSize.height * 0.04,
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                SizedBox(
                  width: ScreenSize.width * 0.6,
                  // padding: EdgeInsets.symmetric(horizontal: marginHorizontal),
                  child: Image(
                    image: AssetImage('assets/logo/oder_rewards.png'),
                  ),
                ),
              ],
            ),
          ),
          _buildScannerButton(),
        ],
      ),
    );
  }

  Widget _buildScannerButton() {
    return InkWell(
      onTap: () {
        Storage().page = 'voucher';
        scanBarcodeNormal();
      },
      child: Container(
        // width: width * 0.2,
        color: colorTransparent,
        child: Container(
          width: ScreenSize.width * 0.13,
          height: ScreenSize.width * 0.13,
          // margin: EdgeInsets.only(right: 5),
          padding: EdgeInsets.all(13),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colorGoldButton,
            border: Border.all(color: colorGreyBox),
          ),
          // child: InkWell(
          //   onTap: () {
          //     Storage().page = 'voucher';
          //     scanBarcodeNormal();
          //   },
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/icons/global/scanner.webp'),
              ),
            ),
          ),
          // ),
        ),
      ),
    );
  }

  Widget _buildTabBarSection() {
    return Container(
      height: 40,
      margin: EdgeInsets.symmetric(horizontal: marginHorizontal, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: TabBar(
              controller: _tabController,
              unselectedLabelColor: colorDarkGray,
              overlayColor: WidgetStateProperty.all(Colors.transparent),
              unselectedLabelStyle: TextStyle(
                fontSize: 11,
                fontFamily: fontFamilyMain,
                fontWeight: FontWeight.w500,
              ),
              indicatorSize: TabBarIndicatorSize.label,
              indicatorWeight: 0,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: colorTransparent,
              ),
              labelColor: colorWhite,
              labelPadding: EdgeInsets.symmetric(horizontal: 4),
              labelStyle: TextStyle(
                fontSize: 11,
                fontFamily: fontFamilyMain,
                fontWeight: FontWeight.w700,
              ),
              onTap: (value) {
                FocusManager.instance.primaryFocus?.unfocus();

                tabChange = true;
                Storage().isTabChange = tabChange;

                setState(() {});
              },
              tabs: [
                Tab(child: _buildTabItem('Deals', 0)),
                Tab(child: _buildTabItem('My Vouchers', 1)),
                Tab(child: _buildTabItem('History', 2)),
              ],
            ),
          ),
          IconButton(
            icon: Image(image: AssetImage('assets/icons/outlet/search.webp')),
            onPressed:
                () => Navigator.of(context).pushNamedAndRemoveUntil(
                  OderRoutes.searchAPIPage,
                  (Route<dynamic> route) => false,
                  arguments: SearchScreenParameters(tabFor: 'voucher'),
                ),
          ),
        ],
      ),
    );
  }

  /* --------------------------------------------------------------------------- Scan barcode function */
  Future<void> scanBarcodeNormal() async {
    /* Navigate to scan view page */
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder:
            (BuildContext context) =>
                AppBarcodeScannerWidget.defaultStyle(tabFor: 'voucher'),
      ),
      (Route<dynamic> route) => false,
    );
  }

  /* --------------------------------------------------------------------------- Session expired function */
  void sessionExpiredLogOut(String error) {
    /* Show error toast */
    showErrorToast('$error\nYou will be logged out.', context);

    /* Call Authentication logout bloc */
    BlocProvider.of<AuthenticationBloc>(context).add(AuthenticationLoggedOut());

    /* Navigate to login page directly */
    Navigator.of(context).pushNamedAndRemoveUntil(
      OderRoutes.login,
      (Route<dynamic> route) => false,
    );
  }
}

/* ----------------------------------------------------------------------------- MyTabs class */
class MyTabs {
  final String title;
  MyTabs({required this.title});
}

/* ----------------------------------------------------------------------------- SliverAppbarDelegate class */
class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => math.max(maxHeight, minHeight);
  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
