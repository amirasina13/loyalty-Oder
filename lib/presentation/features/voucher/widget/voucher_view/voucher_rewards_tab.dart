import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../../app_setting/app_setting.dart';
import '../../../../../data/data.dart';
import '../../../../widgets/extensions/reward_list_view.dart';
import '../../../../widgets/widgets.dart';
import '../../../authentication/authentication.dart';
import '../../../maintenance/maintenance.dart';
import '../../../rewards/reward.dart';
import '../../../webview/webview_deeplink.dart';

class VoucherRewardsTab extends StatefulWidget {
  final String? filterBy;
  final String? filterValue;

  const VoucherRewardsTab({
    super.key,
    required this.filterBy,
    required this.filterValue,
  });

  @override
  State<VoucherRewardsTab> createState() => VoucherRewardsTabState();
}

class VoucherRewardsTabState extends State<VoucherRewardsTab>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  FilterData? filterData;

  String updatedFilterBy = '';
  String updatedFilterValue = '';

  int currentTabIndex = 0;

  late TabController _voucherRewardTabController;
  final Map<int, List<VoucherReward>> rewardsByTab = {};
  final Set<int> exhaustedRewardTabs = {};

  /// Keep track of which tabs have been visited.
  final Set<int> visitedRewardTabs = {0};

  /// Each tab has its own ScrollController.
  final Map<int, ScrollController> scrollControllers = {};
  final Map<String, bool> _favouriteLoadingStates = {};

  /// Used for pagination.
  String pagingFilterBy = 'all';
  String pagingFilterValue = 'all';

  // ---------------------------------------------------------------------------
  // INIT
  // ---------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();

    fToast = FToast();
    fToast.init(context);

    if (Storage().isTabChange == false) {
      updatedFilterBy = widget.filterBy ?? 'all';
      updatedFilterValue = widget.filterValue ?? 'all';
    } else {
      updatedFilterBy = 'all';
      updatedFilterValue = 'all';
    }

    _voucherRewardTabController = TabController(length: 0, vsync: this);

    context.read<RewardBloc>().add(FilterCategoryLoad());
  }

  // ---------------------------------------------------------------------------
  // SCROLL CONTROLLER
  // ---------------------------------------------------------------------------

  ScrollController _controllerFor(int tabIndex) {
    return scrollControllers.putIfAbsent(tabIndex, () {
      final controller = ScrollController();

      controller.addListener(() => _onScrollForTab(tabIndex));

      return controller;
    });
  }

  void _onScrollForTab(int tabIndex) {
    final controller = scrollControllers[tabIndex];

    if (controller == null ||
        !controller.hasClients ||
        tabIndex != currentTabIndex ||
        exhaustedRewardTabs.contains(tabIndex) ||
        controller.position.userScrollDirection != ScrollDirection.reverse) {
      return;
    }

    if (controller.position.pixels >=
        controller.position.maxScrollExtent - 200) {
      final bloc = context.read<RewardBloc>();

      if (!bloc.isRewardFetching) {
        final filterBy = _filterByForTab(tabIndex);
        final filterValue = _filterValueForTab(tabIndex);

        pagingFilterBy = filterBy;
        pagingFilterValue = filterValue;

        bloc
          ..isRewardFetching = true
          ..add(RewardListLoad(filterBy: filterBy, filterValue: filterValue));
      }
    }
  }

  // ---------------------------------------------------------------------------
  // GET FILTER FOR TAB
  // ---------------------------------------------------------------------------

  String _filterByForTab(int tabIndex) {
    return tabIndex == 0 ? 'all' : 'category';
  }

  String _filterValueForTab(int tabIndex) {
    if (tabIndex == 0) {
      return 'all';
    }

    if (filterData?.options == null) {
      return '';
    }

    final optionIndex = tabIndex - 1;

    if (optionIndex < 0 || optionIndex >= filterData!.options!.length) {
      return '';
    }

    return filterData!.options![optionIndex].id.toString();
  }

  // ---------------------------------------------------------------------------
  // GET CURRENT TAB REWARDS
  // ---------------------------------------------------------------------------

  List<VoucherReward> _rewardsForTab(int tabIndex) {
    return rewardsByTab[tabIndex] ?? <VoucherReward>[];
  }

  // ---------------------------------------------------------------------------
  // CLEAR TAB
  // ---------------------------------------------------------------------------

  void _clearTabRewards(int tabIndex) {
    rewardsByTab[tabIndex] = <VoucherReward>[];
    exhaustedRewardTabs.remove(tabIndex);
  }

  // ---------------------------------------------------------------------------
  // TAB CLICK
  // ---------------------------------------------------------------------------

  void _onTabSelected(int tabIndex) {
    FocusManager.instance.primaryFocus?.unfocus();

    final targetFilterBy = _filterByForTab(tabIndex);
    final targetFilterValue = _filterValueForTab(tabIndex);

    setState(() {
      currentTabIndex = tabIndex;

      visitedRewardTabs.add(tabIndex);

      // IMPORTANT:
      // Clear ONLY the selected tab's old rewards.
      _clearTabRewards(tabIndex);
    });

    final bloc = context.read<RewardBloc>();

    pagingFilterBy = targetFilterBy;
    pagingFilterValue = targetFilterValue;

    // Reset pagination.
    bloc
      ..rewardPage = 0
      ..isRewardFetching = true
      ..add(
        RewardListLoad(
          filterBy: targetFilterBy,
          filterValue: targetFilterValue,
        ),
      );
  }

  // ---------------------------------------------------------------------------
  // DISPOSE
  // ---------------------------------------------------------------------------

  @override
  void dispose() {
    for (final controller in scrollControllers.values) {
      controller.dispose();
    }

    _voucherRewardTabController.dispose();

    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<RewardBloc, RewardState>(
      listener: (context, state) {
        // ---------------------------------------------------------------------
        // FILTER CATEGORY LOADED
        // ---------------------------------------------------------------------

        if (state is FilterCategoryLoaded) {
          filterData = state.filterData;

          final newLength = filterData!.options!.length + 1;

          // Find the category passed from previous page.
          //
          // IMPORTANT:
          // Compare String to String because widget.filterValue
          // is passed using category.id.toString().
          final initialIndexTab = filterData!.options!.indexWhere(
            (el) => el.id.toString() == widget.filterValue.toString(),
          );

          final selectedIndex =
              updatedFilterBy == 'all'
                  ? 0
                  : (initialIndexTab >= 0 ? initialIndexTab + 1 : 0);

          // Create TabController.
          if (_voucherRewardTabController.length != newLength) {
            _voucherRewardTabController.dispose();

            _voucherRewardTabController = TabController(
              length: newLength,
              vsync: this,
              initialIndex: selectedIndex,
            );
          } else {
            if (_voucherRewardTabController.index != selectedIndex) {
              _voucherRewardTabController.index = selectedIndex;
            }
          }

          // Set current tab.
          currentTabIndex = selectedIndex;

          // Make sure selected tab is visited.
          visitedRewardTabs.add(selectedIndex);

          // Clear selected tab's old data.
          _clearTabRewards(selectedIndex);

          // Initial API request.
          final targetFilterBy = updatedFilterBy == 'all' ? 'all' : 'category';

          final targetFilterValue =
              updatedFilterBy == 'all' ? 'all' : updatedFilterValue;

          pagingFilterBy = targetFilterBy;
          pagingFilterValue = targetFilterValue;

          context.read<RewardBloc>()
            ..rewardPage = 0
            ..isRewardFetching = true
            ..add(
              RewardListLoad(
                filterBy: targetFilterBy,
                filterValue: targetFilterValue,
              ),
            );
        }

        // ---------------------------------------------------------------------
        // REWARD LIST LOADED
        // ---------------------------------------------------------------------

        if (state is RewardAddRemoveFavouriteLoaded) {
          setState(() {
            _favouriteLoadingStates.remove(state.voucherId);
          });
        }

        if (state is RewardListLoaded) {
          final currentTab = currentTabIndex;
          if (!state.hasMore) {
            exhaustedRewardTabs.add(currentTab);
          }

          final newRewards =
              (state.voucherRewards.vouchers ?? [])
                  .where((voucher) => voucher.purchaseMethod != 'redeemable')
                  .toList();

          final currentRewards = rewardsByTab[currentTab] ?? <VoucherReward>[];

          // Refresh existing items too, including their favourite status.
          for (final item in newRewards) {
            final index = currentRewards.indexWhere(
              (existing) => existing.id == item.id,
            );
            if (index < 0) {
              currentRewards.add(item);
            } else {
              currentRewards[index] = item;
            }
          }

          setState(() {
            rewardsByTab[currentTab] = currentRewards;
          });

          context.read<RewardBloc>().isRewardFetching = false;
        }

        // ---------------------------------------------------------------------
        // REWARD EMPTY
        // ---------------------------------------------------------------------

        if (state is RewardEmpty) {
          exhaustedRewardTabs.add(currentTabIndex);
          context.read<RewardBloc>().isRewardFetching = false;

          setState(() {
            rewardsByTab[currentTabIndex] = <VoucherReward>[];
          });
        }

        // ---------------------------------------------------------------------
        // NO MORE PAGINATION
        // ---------------------------------------------------------------------

        if (state is RewardListStop) {
          exhaustedRewardTabs.add(currentTabIndex);
          showPaginationToast('No more deals', context);

          context.read<RewardBloc>().isRewardFetching = false;
        }

        // ---------------------------------------------------------------------
        // ERRORS
        // ---------------------------------------------------------------------

        if (state is RewardError) {
          _favouriteLoadingStates.clear();
          context.read<RewardBloc>().isRewardFetching = false;

          showErrorToast(state.error, context);
        }

        if (state is RewardSessionError) {
          context.read<RewardBloc>().isRewardFetching = false;

          sessionExpiredLogOut(state.error);
        }

        if (state is RewardNetworkError) {
          context.read<RewardBloc>().isRewardFetching = false;

          showErrorToast('No internet connection', context);

          Navigator.of(context).pushNamedAndRemoveUntil(
            OderRoutes.home,
            (Route<dynamic> route) => false,
          );
        }

        if (state is RewardMaintenanceError) {
          context.read<RewardBloc>().isRewardFetching = false;

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

      // -----------------------------------------------------------------------
      // BUILDER
      // -----------------------------------------------------------------------
      builder: (context, state) {
        if (state is RewardInitial) {
          return Column(
            children: [
              Container(height: ScreenSize.height * 0.04),
              Expanded(child: LoadingWidget()),
            ],
          );
        }

        if (filterData == null) {
          return Column(
            children: [
              Container(height: ScreenSize.height * 0.04),
              Expanded(child: LoadingWidget()),
            ],
          );
        }

        return Column(
          children: [
            // -----------------------------------------------------------------
            // TAB BAR
            // -----------------------------------------------------------------
            Container(
              color: colorGreyBox,
              height: ScreenSize.height * 0.04,
              width: ScreenSize.width,
              padding: EdgeInsets.only(
                left: marginHorizontal,
                right: marginHorizontal,
              ),
              child: TabBar(
                isScrollable: true,
                controller: _voucherRewardTabController,
                unselectedLabelColor: colorTextGrey,
                padding: EdgeInsets.zero,
                unselectedLabelStyle: TextStyle(
                  fontSize:
                      (MediaQuery.of(context).size.width < 400 ||
                              MediaQuery.of(context).size.height < 400)
                          ? 12
                          : 13,
                  fontFamily: fontFamilyMain,
                  fontWeight: FontWeight.w500,
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: colorMulberry,
                indicatorPadding: EdgeInsets.only(right: 20),
                labelColor: mainColor,
                labelPadding: EdgeInsets.only(right: 20),
                labelStyle: TextStyle(
                  fontSize:
                      (MediaQuery.of(context).size.width < 400 ||
                              MediaQuery.of(context).size.height < 400)
                          ? 12
                          : 13,
                  fontFamily: fontFamilyMain,
                  fontWeight: FontWeight.w700,
                ),

                onTap: _onTabSelected,

                tabs: [
                  Tab(
                    child: Text('For You', style: TextStyle(color: colorBlack)),
                  ),

                  for (int i = 0; i < filterData!.options!.length; i++)
                    Tab(child: Text(filterData!.options![i].name!)),
                ],
              ),
            ),

            // -----------------------------------------------------------------
            // TAB CONTENT
            // -----------------------------------------------------------------
            Expanded(
              child: TabBarView(
                controller: _voucherRewardTabController,
                children: [
                  // -----------------------------------------------------------
                  // ALL / FOR YOU
                  // -----------------------------------------------------------
                  _buildRewardTab(context, 0, state),

                  // -----------------------------------------------------------
                  // CATEGORY TABS
                  // -----------------------------------------------------------
                  for (int i = 0; i < filterData!.options!.length; i++)
                    _buildRewardTab(context, i + 1, state),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // BUILD ONE TAB
  // ---------------------------------------------------------------------------

  Widget _buildRewardTab(
    BuildContext context,
    int tabIndex,
    RewardState state,
  ) {
    final filterBy = _filterByForTab(tabIndex);

    final filterValue = _filterValueForTab(tabIndex);

    final rewards = _rewardsForTab(tabIndex);

    final bool isCurrentTab = currentTabIndex == tabIndex;

    // Only show loading on the currently requested tab.
    if (isCurrentTab && (state is RewardLoading || state is RewardInitial)) {
      return LoadingWidget();
    }

    // Current tab has no rewards.
    if (rewards.isEmpty) {
      return emptyDeals();
    }

    return Column(
      children: [
        Expanded(
          child: _buildRewardListView(
            context,
            rewards,
            filterBy,
            filterValue,
            tabIndex,
            state,
          ),
        ),

        if (isCurrentTab && state is RewardNextLoading)
          SizedBox(child: LoadingWidget()),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // REWARD LIST
  // ---------------------------------------------------------------------------

  Widget _buildRewardListView(
    BuildContext context,
    List<VoucherReward> rewards,
    String filterBy,
    String filterValue,
    int tabIndex,
    RewardState state,
  ) {
    return Container(
      margin: EdgeInsets.fromLTRB(marginHorizontal, 10, marginHorizontal, 0),
      child: ListView.builder(
        padding: EdgeInsets.only(bottom: 30),
        controller: _controllerFor(tabIndex),
        itemCount: rewards.length,
        itemBuilder: (BuildContext context, int index) {
          final reward = rewards[index];

          final bool isItemLoading =
              _favouriteLoadingStates[reward.id!] ?? false;

          return reward.getRewardListTile(
            context: context,

            // -----------------------------------------------------------------
            // REWARD DETAIL
            // -----------------------------------------------------------------
            onTap: () {
              TempData.voucherRefCode = '';
              Storage().page = '';

              Navigator.of(context)
                  .pushNamed(
                    OderRoutes.rewardDetails,
                    arguments: RewardDetailsParameters(
                      rewardId: reward.id.toString(),
                      title: reward.name!,
                      indexPage: 3,
                    ),
                  )
                  .then((value) {
                    if (!context.mounted) {
                      return;
                    }

                    final bloc = context.read<RewardBloc>();

                    // Reload the SAME category.
                    _clearTabRewards(tabIndex);

                    bloc
                      ..rewardPage = 0
                      ..isRewardFetching = true
                      ..add(
                        RewardListLoad(
                          filterBy: filterBy,
                          filterValue: filterValue,
                        ),
                      );
                  });
            },

            // -----------------------------------------------------------------
            // FAVOURITE
            // -----------------------------------------------------------------
            onFavouriteTap: () {
              if (_favouriteLoadingStates[reward.id!] == true) return;
              setState(() {
                _favouriteLoadingStates[reward.id!] = true;
              });

              Storage().page = 'reward_wishlist';

              context.read<RewardBloc>().add(
                RewardAddRemoveFavouriteLoad(
                  voucherId: reward.id!.toString(),
                  filterBy: filterBy,
                  filterValue: filterValue,
                ),
              );
            },

            isFavClick: isItemLoading,
          );
        },
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // EMPTY
  // ---------------------------------------------------------------------------

  Widget emptyDeals() {
    return Center(
      child: Container(
        color: colorBackground,
        height: ScreenSize.height * 0.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: ScreenSize.width * 0.18,
              width: ScreenSize.width * 0.18,
              padding: EdgeInsets.symmetric(
                vertical: ScreenSize.height / 12,
                horizontal: ScreenSize.width,
              ),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.contain,
                  image: AssetImage('assets/icons/no_deals.webp'),
                ),
              ),
            ),
            SizedBox(height: ScreenSize.height * 0.03),
            Text(
              'No Deals Yet',
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

  // ---------------------------------------------------------------------------
  // SESSION EXPIRED
  // ---------------------------------------------------------------------------

  void sessionExpiredLogOut(String error) {
    showErrorToast('$error\nYou will be logged out.', context);

    BlocProvider.of<AuthenticationBloc>(context).add(AuthenticationLoggedOut());

    Navigator.of(context).pushNamedAndRemoveUntil(
      OderRoutes.login,
      (Route<dynamic> route) => false,
    );
  }
}
