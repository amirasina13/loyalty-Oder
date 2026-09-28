import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../app_setting/app_setting.dart';
import '../../../../util/utils.dart';
import '../../../widgets/widgets.dart';
import '../../ordering/ordering.dart';
import '../../outlet/outlet.dart';
import '../../rewards/reward.dart';
import '../../voucher/voucher.dart';
import '../home.dart';

class SearchViewNew extends StatefulWidget {
  final Function changeView;
  final String tabFor;

  const SearchViewNew({
    super.key,
    required this.changeView,
    required this.tabFor,
  });

  @override
  State<SearchViewNew> createState() => _SearchViewNewState();
}

class _SearchViewNewState extends State<SearchViewNew>
    with TickerProviderStateMixin {
  int? selectedCategory;
  String updatedFilterBy = '', updatedFilterValue = '';
  List<String> _searchHistory = [];
  List<String> _displayedHistory = []; // Separate list for the UI
  List<dynamic> searchListData = [];
  List<String> tabTitles = [];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;

  final FocusNode searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    // Load search history from shared_preferences (if you implement persistence)
    _loadSearchHistory();

    _tabController = TabController(length: 0, vsync: this);

    // Request focus after page is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      searchFocus.requestFocus();
    });
  }

  // Helper to get account-scoped search key
  String _getSearchHistoryKey() {
    final userKey =
        Storage().email.isNotEmpty ? Storage().email : Storage().contact;
    return userKey.isNotEmpty
        ? 'searchHistory_$userKey'
        : 'searchHistory_guest';
  }

  Future<void> _loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final loadedHistory = prefs.getStringList(_getSearchHistoryKey()) ?? [];
    setState(() {
      _searchHistory = loadedHistory;
      _displayedHistory = List.from(
        _searchHistory,
      ); // Initialize displayed history
    });
  }

  Future<void> _saveSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_getSearchHistoryKey(), _searchHistory);
  }

  void _addSearchToHistory(String query) {
    if (query.isNotEmpty && !_searchHistory.contains(query)) {
      setState(() {
        _searchHistory.insert(0, query); // Add to the beginning
        if (_searchHistory.length > 10) {
          // Limit history size
          _searchHistory.removeLast();
        }
      });

      // Save the search history when the screen is disposed
      _saveSearchHistory();
    }
  }

  void _handleSearch(String query) {
    if (query.isNotEmpty) {
      _addSearchToHistory(query);

      BlocProvider.of<HomeBloc>(context).add(
        SearchLoad(
          keywords: query,
          type:
              widget.tabFor == 'home'
                  ? 'all'
                  : widget.tabFor == 'brand'
                  ? 'merchant'
                  : 'voucher',
        ),
      );
      // _searchController.clear();

      // print('Searching for: $query');
      // Perform your actual search logic here
    } else {
      BlocProvider.of<HomeBloc>(context).add(SearchClearLoad());
    }
  }

  void _handleHistoryItemTap(String historyItem) {
    searchFocus.unfocus();

    setState(() {
      _searchController.text = historyItem;
    });
    // Optionally perform a search when a history item is tapped
    _handleSearch(historyItem);
  }

  @override
  void dispose() {
    super.dispose();

    _searchController.dispose();
    _tabController.dispose();

    searchFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (widget.tabFor == 'voucher') {
          Navigator.of(context).pushNamedAndRemoveUntil(
            OderRoutes.voucher,
            (Route<dynamic> route) => false,
            arguments: VoucherParameters(
              selectedTab: 0,
              filterBy: 'all',
              filterValue: '1',
            ),
          );
        } else {
          Navigator.pop(context);
        }
      },
      child: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          // if (state is SearchLoaded) {
          //   // print('LISTEN SEARCHSTATE: ${state.searchData!.length}');
          // }
        },
        builder: (context, state) {
          return OderScaffold(
            scaffoldKey: _scaffoldKey,
            systemUiOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: colorWhite,
              systemNavigationBarColor: colorWhite,
            ),
            showAppbar: false,
            bottomMenuIndex: 0,
            // Disable opening the end drawer with a swipe gesture.
            endDrawerEnableOpenDragGesture: false,
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: marginHorizontal),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: ScreenSize.height * 0.075,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () async {
                              if (widget.tabFor == 'voucher') {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  OderRoutes.voucher,
                                  (Route<dynamic> route) => false,
                                  arguments: VoucherParameters(
                                    selectedTab: 0,
                                    filterBy: 'all',
                                    filterValue: '1',
                                  ),
                                );
                              } else {
                                Navigator.pop(context);
                              }
                            },
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: colorBackSearch,
                            ),
                          ),
                          _searchBar(true),
                        ],
                      ),
                    ),
                    SizedBox(height: ScreenSize.height * 0.002),
                    _searchHistory.isEmpty || _displayedHistory.isEmpty
                        ? SizedBox()
                        : Container(
                          height:
                              Platform.isAndroid
                                  ? ScreenSize.height * 0.023
                                  : ScreenSize.height * 0.03,
                          margin: EdgeInsets.only(
                            bottom: ScreenSize.height * 0.01,
                          ),
                          child: Text(
                            'History',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    _searchHistory.isEmpty
                        ? SizedBox()
                        : Container(
                          margin: EdgeInsets.only(
                            bottom: ScreenSize.height * 0.01,
                          ),
                          // You can still set a minimum or maximum height if needed
                          // height:
                          //     double.infinity, // To take up all remaining height
                          child: Wrap(
                            spacing: 8.0, // Spacing between chips
                            runSpacing: 4.0, // Spacing between lines of chips
                            children:
                                _displayedHistory.map((item) {
                                  return InkWell(
                                    onTap: () {
                                      _handleHistoryItemTap(item);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 8.0,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            Colors
                                                .grey
                                                .shade200, // Background color for history item
                                        borderRadius: BorderRadius.circular(
                                          20.0,
                                        ),
                                      ),
                                      child: Text(item),
                                    ),
                                  );
                                }).toList(),
                          ),
                        ),
                    _searchResult(state),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Search bar
  Widget _searchBar(bool? showSuffix) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(color: colorWhite),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: colorWhite,
            border: Border.all(color: colorGreyBox),
            borderRadius: BorderRadius.circular(30),
          ),
          child: TextField(
            controller: _searchController,
            textInputAction: TextInputAction.search,
            onSubmitted: _handleSearch,
            focusNode: searchFocus,
            style: TextStyle(
              color: colorBlack,
              fontSize: 15,
              fontWeight: FontWeight.w300,
            ),
            // onChanged: (value) {
            //   if (value.isEmpty) {
            //     // FocusScope.of(context).unfocus();
            //     _handleSearch(value);
            //   }
            // },
            decoration: InputDecoration(
              isDense: true, // Minimizes vertical padding for better alignment
              contentPadding: EdgeInsets.symmetric(vertical: 15),
              hintText: "Burger",
              hintStyle: TextStyle(
                color: colorSoftGrey,
                fontSize: 13,
                fontWeight: FontWeight.w400,
                fontFamily: fontFamilyMain,
              ),
              prefixIcon: Padding(
                padding: EdgeInsets.only(left: 5, right: 10),
                child: Image.asset(
                  'assets/icons/outlet/search.webp',
                  width: 20,
                ),
              ),
              prefixIconConstraints: BoxConstraints(
                minWidth: 20,
                minHeight: 20,
              ),
              suffixIconConstraints: BoxConstraints(
                minWidth: 20,
                minHeight: 20,
              ),
              suffixIcon:
                  _searchController.text.isNotEmpty
                      ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            searchFocus.requestFocus();

                            _handleSearch(_searchController.text);
                          });
                        },
                      )
                      : Container(
                        margin: EdgeInsets.only(top: 5),
                        child: Text(
                          "Search",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: colorTextGrey,
                          ),
                        ),
                      ),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }

  Widget _searchResult(HomeState state) {
    final Map<String, List<Map<String, dynamic>>> groupedMap = {};
    List<dynamic> newList = [];

    if (state is SearchLoaded) {
      searchListData = state.searchData!;

      for (var item in searchListData) {
        if (item is Map<String, dynamic>) {
          final key = item['type']?.toString() ?? 'Unknown';
          groupedMap.putIfAbsent(key, () => []);
          groupedMap[key]!.add(item);
        }
      }

      // Sort the keys alphabetically
      final sortedKeys =
          groupedMap.keys.toList()
            ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

      // Create the newList based on the sorted keys
      newList = sortedKeys.map((key) => [key, groupedMap[key]]).toList();

      // // Convert the Map to a List in the desired format
      // newList =
      //     groupedMap.entries.map((entry) {
      //       return [entry.key, entry.value];
      //     }).toList();

      tabTitles = newList.map((group) => group[0] as String).toList();

      // Sort the list alphabetically (in-place modification)
      tabTitles.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

      if (_tabController.length != tabTitles.length) {
        int oldIndex = _tabController.index; // keep current index
        _tabController.dispose();
        _tabController = TabController(
          length: tabTitles.length + 1,
          vsync: this,
          initialIndex: oldIndex.clamp(0, tabTitles.length - 1),
        );
      }

      return widget.tabFor == 'voucher'
          ? Flexible(
            child: Container(
              padding: EdgeInsets.only(
                bottom:
                    _searchHistory.isEmpty || _displayedHistory.isEmpty
                        ? 0
                        : ScreenSize.height * 0.06,
              ),
              child:
                  state is HomeError
                      ? _emptyListWidget()
                      : ListView.builder(
                        // shrinkWrap: true,
                        padding: EdgeInsets.only(
                          bottom:
                              _searchHistory.isEmpty ||
                                      _displayedHistory.isEmpty
                                  ? ScreenSize.height * 0.02
                                  : ScreenSize.height * 0.05,
                        ),
                        itemCount: searchListData.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              searchListData[index]['type'] == 'voucher'
                                  ? Navigator.of(context).pushNamed(
                                    OderRoutes.rewardDetails,
                                    arguments: RewardDetailsParameters(
                                      rewardId:
                                          searchListData[index]['id']
                                              .toString(),
                                      title: searchListData[index]['name'],
                                      indexPage: 2,
                                    ),
                                  )
                                  : searchListData[index]['type'] == 'outlet'
                                  ? Navigator.of(context)
                                      .pushNamed(
                                        OderRoutes.outletDetails,
                                        arguments: OutletDetailsParameters(
                                          outletId:
                                              searchListData[index]['id']
                                                  .toString(),
                                          outlet: searchListData[index]['name'],
                                        ),
                                      )
                                      .then((value) {})
                                  : searchListData[index]['type'] == 'merchant'
                                  ? Navigator.of(context)
                                      .pushNamed(
                                        OderRoutes.orderingOutlet,
                                        arguments: OrderingOutletParameters(
                                          brandsId:
                                              searchListData[index]['id']
                                                  .toString(),
                                        ),
                                      )
                                      .then((value) {})
                                  : null;
                            },
                            child: Container(
                              color: colorBackground,
                              constraints: BoxConstraints(
                                minHeight: ScreenSize.height * 0.07,
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 8,
                              ), // Add padding for breathing room
                              margin: const EdgeInsets.only(bottom: 5),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: CachedImage(
                                      imageUrl: searchListData[index]['image'],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  searchListData[index]['description']
                                          .isNotEmpty
                                      ? Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              searchListData[index]['name'],
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              searchListData[index]['description'],
                                              maxLines: 5,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: colorBlack,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                      : Expanded(
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            searchListData[index]['name'],
                                          ),
                                        ),
                                      ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
            ),
          )
          : Flexible(
            child: DefaultTabController(
              length: tabTitles.length,
              child: Column(
                children: [
                  TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    indicatorColor: colorGoldButton,
                    indicatorPadding: EdgeInsets.zero,
                    tabs: [
                      Tab(text: 'All'),
                      ...tabTitles.map(
                        (title) => Tab(text: capitalizeFirstLetter(title)),
                      ),
                    ],
                    labelColor: mainColor,
                    // onTap: (value) {
                    //   setState(() {
                    //     selectedType =
                    //         updatedFacets[value].value == 'All'
                    //             ? null
                    //             : updatedFacets[value].value.toLowerCase();
                    //   });
                    //   algoliaSearch();
                    // },
                  ),
                  newList.isNotEmpty
                      ? Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            ListView.builder(
                              itemCount: searchListData.length,
                              padding: EdgeInsets.only(
                                bottom:
                                    _searchHistory.isEmpty ||
                                            _displayedHistory.isEmpty
                                        ? ScreenSize.height * 0.02
                                        : ScreenSize.height * 0.05,
                              ),
                              itemBuilder: (context, itemIndex) {
                                // final item =
                                //     itemsOfType[itemIndex] as Map<String, dynamic>;

                                return InkWell(
                                  onTap: () {
                                    searchListData[itemIndex]['type'] ==
                                            'voucher'
                                        ? Navigator.of(context).pushNamed(
                                          OderRoutes.rewardDetails,
                                          arguments: RewardDetailsParameters(
                                            rewardId:
                                                searchListData[itemIndex]['id']
                                                    .toString(),
                                            title:
                                                searchListData[itemIndex]['name'],
                                            indexPage: 2,
                                          ),
                                        )
                                        : searchListData[itemIndex]['type'] ==
                                            'outlet'
                                        ? Navigator.of(context)
                                            .pushNamed(
                                              OderRoutes.outletDetails,
                                              arguments: OutletDetailsParameters(
                                                outletId:
                                                    searchListData[itemIndex]['id']
                                                        .toString(),
                                                outlet:
                                                    searchListData[itemIndex]['name'],
                                              ),
                                            )
                                            .then((value) {})
                                        : searchListData[itemIndex]['type'] ==
                                            'merchant'
                                        ? Navigator.of(context)
                                            .pushNamed(
                                              OderRoutes.orderingOutlet,
                                              arguments: OrderingOutletParameters(
                                                brandsId:
                                                    searchListData[itemIndex]['id']
                                                        .toString(),
                                              ),
                                            )
                                            .then((value) {})
                                        : null;
                                  },
                                  child: Container(
                                    color: colorBackground,
                                    constraints: BoxConstraints(
                                      minHeight: ScreenSize.height * 0.07,
                                    ),
                                    padding: const EdgeInsets.all(8),
                                    margin: const EdgeInsets.only(bottom: 5),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 50,
                                          height: 50,
                                          child: CachedImage(
                                            imageUrl:
                                                searchListData[itemIndex]['image'],
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        searchListData[itemIndex]['description']
                                                .isNotEmpty
                                            ? Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    searchListData[itemIndex]['name'],
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    searchListData[itemIndex]['description'],
                                                    maxLines: 5,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      color: colorBlack,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                            : Expanded(
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  searchListData[itemIndex]['name'],
                                                ),
                                              ),
                                            ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            ...newList.map((group) {
                              final itemsOfType = group[1] as List<dynamic>;

                              return state is HomeError
                                  ? _emptyListWidget()
                                  : ListView.builder(
                                    key: PageStorageKey<String>(
                                      group[0] as String,
                                    ),
                                    itemCount: itemsOfType.length,
                                    padding: EdgeInsets.only(
                                      bottom:
                                          _searchHistory.isEmpty ||
                                                  _displayedHistory.isEmpty
                                              ? ScreenSize.height * 0.02
                                              : ScreenSize.height * 0.05,
                                    ),
                                    itemBuilder: (context, itemIndex) {
                                      final item =
                                          itemsOfType[itemIndex]
                                              as Map<String, dynamic>;

                                      return InkWell(
                                        onTap: () {
                                          item['type'] == 'voucher'
                                              ? Navigator.of(context).pushNamed(
                                                OderRoutes.rewardDetails,
                                                arguments:
                                                    RewardDetailsParameters(
                                                      rewardId:
                                                          item['id'].toString(),
                                                      title: item['name'],
                                                      indexPage: 2,
                                                    ),
                                              )
                                              : item['type'] == 'outlet'
                                              ? Navigator.of(context)
                                                  .pushNamed(
                                                    OderRoutes.outletDetails,
                                                    arguments:
                                                        OutletDetailsParameters(
                                                          outletId:
                                                              item['id']
                                                                  .toString(),
                                                          outlet: item['name'],
                                                        ),
                                                  )
                                                  .then((value) {})
                                              : item['type'] == 'merchant'
                                              ? Navigator.of(context)
                                                  .pushNamed(
                                                    OderRoutes.orderingOutlet,
                                                    arguments:
                                                        OrderingOutletParameters(
                                                          brandsId:
                                                              item['id']
                                                                  .toString(),
                                                        ),
                                                  )
                                                  .then((value) {})
                                              : null;
                                        },
                                        child: Container(
                                          color: colorBackground,
                                          constraints: BoxConstraints(
                                            minHeight: ScreenSize.height * 0.07,
                                          ),
                                          padding: const EdgeInsets.all(8),
                                          margin: const EdgeInsets.only(
                                            bottom: 5,
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: 50,
                                                height: 50,
                                                child: CachedImage(
                                                  imageUrl: item['image'],
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              searchListData[itemIndex]['description']
                                                      .isNotEmpty
                                                  ? Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                          searchListData[itemIndex]['name'],
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 4,
                                                        ),
                                                        Text(
                                                          searchListData[itemIndex]['description'],
                                                          maxLines: 5,
                                                          overflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                          style: TextStyle(
                                                            fontSize: 10,
                                                            color: colorBlack,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                  : Expanded(
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        searchListData[itemIndex]['name'],
                                                      ),
                                                    ),
                                                  ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                            }),
                          ],
                        ),
                      )
                      : Center(child: Text('No data to display.')),
                ],
              ),
            ),
          );
    }

    if (state is HomeProcessing) {
      return Flexible(child: Center(child: LoadingWidget()));
    }

    if (state is SearchClearLoad) {
      return Flexible(child: Center(child: _firstLoadWidget()));
    }

    if (state is SearchEmpty) {
      return Flexible(child: Center(child: _emptyListWidget()));
    }

    return Flexible(child: Center(child: _firstLoadWidget()));
  }

  Widget _firstLoadWidget() {
    return Container(
      width: ScreenSize.width,
      color: colorBackground,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: ScreenSize.height * 0.06,
            color: colorNoVoucherGrey,
          ),
          SizedBox(height: ScreenSize.height * 0.02),
          Text(
            "Type keyword to search",
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

  Widget _emptyListWidget() {
    return Container(
      width: ScreenSize.width,
      color: colorBackground,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            FontAwesomeIcons.circleExclamation,
            size: 40,
            color: colorNoVoucherGrey,
          ),
          SizedBox(height: ScreenSize.height * 0.03),
          Text(
            "No Available Brands or Vouchers",
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
}
