// import 'dart:convert';

// import 'package:http/http.dart' as http;
// import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
// import 'package:flutter/services.dart';
// import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fluttertoast/fluttertoast.dart';

// import '../../../../config/config.dart';
// import '../../../../data/data.dart';
// import '../../../../locator.dart';
// import '../../../../util/utils.dart';
// import '../../../widgets/widgets.dart';
// import '../../authentication/authentication.dart';
// import '../../ordering/ordering.dart';
// import '../../outlet/outlet.dart';
// import '../../rewards/reward.dart';
// import '../../voucher/voucher.dart';
// import '../home.dart';

// class SearchView extends StatefulWidget {
//   final Function? changeView;

//   const SearchView({super.key, this.changeView});

//   @override
//   State<SearchView> createState() => _SearchViewState();
// }

// class _SearchViewState extends State<SearchView> with TickerProviderStateMixin {
//   List<dynamic> searchResults = [];
//   List<dynamic> allSearchResults = [];
//   List<SearchListsModel> allMerchantList = [];
//   List<SearchListsModel> allVouchersList = [];
//   List<SearchListsModel> allOutletList = [];
//   TextEditingController searchController = TextEditingController();
//   final ScrollController _merchantController = ScrollController();
//   final ScrollController _voucherController = ScrollController();

//   TextEditingController algoliaSearchController = TextEditingController();
//   bool isLoading = true;
//   bool showVouchers = true;
//   bool showMerchants = true;

//   bool isSelected = false;
//   String? selectedType;
//   List<dynamic> _searchResults = [];
//   FilterData? filterData;
//   FilterData? filterBlocState;
//   int? selectedCategory;
//   BuildContext? blocContext;

//   String updatedFilterBy = '', updatedFilterValue = '';
//   final PagingController<int, Product> _pagingController = PagingController(
//     firstPageKey: 0,
//   );
//   final ValueNotifier<bool> _isSearching = ValueNotifier(false);
//   final ValueNotifier<bool> _isHistoryLoading = ValueNotifier(false);
//   final productsSearcher = HitsSearcher(
//     applicationID: 'UGRS8UT0F0',
//     apiKey: 'f65a0dc643e4a91549c0262b4101f693',
//     indexName: 'all_data',
//   );
//   // Stream<SearchMetadata> get _searchMetadata =>
//   //     productsSearcher.responses.map(SearchMetadata.fromResponse);
//   Stream<HitsPage> get _searchPage =>
//       productsSearcher.responses.map(HitsPage.fromResponse);
//   late TabController? _tabController;
//   List<Facet> updatedFacets = [];

//   // Create a FilterState
//   final filterState = FilterState();
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   @override
//   void initState() {
//     super.initState();
//     getHitsData();
//     BlocProvider.of<HomeBloc>(context).add(VoucherBrandLoad());
//     fToast = FToast();
//     fToast.init(context);
//     _tabController = TabController(length: updatedFacets.length, vsync: this);

//     fetchSearches();
//     algoliaSearch();
//   }

//   // Method to initialize TabController
//   void _initializeTabController() {
//     _tabController = TabController(length: updatedFacets.length, vsync: this);

//     // Add listener for TabController changes
//     _tabController!.addListener(() {
//       if (!_tabController!.indexIsChanging) {
//         setState(() {
//           selectedType =
//               _tabController!.index == 0
//                   ? null
//                   : updatedFacets[_tabController!.index].value.toLowerCase();
//           algoliaSearch();
//         });
//       }

//       // print('updatedFacets: ${updatedFacets[_tabController!.index]}');
//       // print('_tabController index: ${_tabController!.index}');
//       // print('selectedType: $selectedType');
//     });
//   }

//   /* --------------------------------------------------------------------------- dispose - Called when this object is removed from the tree permanently. */
//   @override
//   void dispose() {
//     super.dispose();

//     _merchantController.dispose();
//     _voucherController.dispose();
//     _tabController?.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<HomeBloc, HomeState>(
//       listener: (context, state) {
//         if (state is HomeNetworkError) {
//           showErrorToast(state.error, context);
//         }

//         if (state is VoucherBrandLoaded) {
//           setState(() {
//             isLoading = false;
//             searchResults = state.searchData!;
//           });
//         }
//       },
//       builder: (context, state) {
//         return OderScaffold(
//           scaffoldKey: _scaffoldKey,
//           systemUiOverlayStyle: SystemUiOverlayStyle(
//             statusBarColor: colorWhite,
//             systemNavigationBarColor: colorWhite,
//           ),
//           showAppbar: false,
//           bottomMenuIndex: 0,
//           endDrawer: buildDrawer(
//             context,
//             ScreenSize.height,
//             ScreenSize.width,
//             "",
//             "",
//           ),
//           // Disable opening the end drawer with a swipe gesture.
//           endDrawerEnableOpenDragGesture: false,
//           body: Stack(
//             children: [
//               Column(
//                 children: [
//                   SizedBox(height: 50),
//                   Flexible(child: _algoliaSearchbar(true)),
//                 ],
//               ),
//               if (isLoading) LoadingWidget(),
//               if (searchResults.isEmpty && !isLoading)
//                 Center(child: _emptyListWidget()),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   // // Search bar
//   Widget _searchBar(bool? showSuffix) {
//     return Expanded(
//       child: Container(
//         padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//         decoration: BoxDecoration(color: colorWhite),
//         child: Container(
//           padding: EdgeInsets.symmetric(horizontal: 15),
//           decoration: BoxDecoration(
//             color: colorWhite,
//             border: Border.all(color: colorGreyBox),
//             borderRadius: BorderRadius.circular(30),
//           ),
//           child: TextField(
//             controller: algoliaSearchController,
//             textInputAction: TextInputAction.search,
//             onSubmitted: (_) {
//               textSearchMethod();
//             },
//             style: TextStyle(
//               color: colorBlack,
//               fontSize: 15,
//               fontWeight: FontWeight.w300,
//             ),
//             decoration: InputDecoration(
//               isDense: true, // Minimizes vertical padding for better alignment
//               contentPadding: EdgeInsets.symmetric(vertical: 15),
//               hintText: "Burger",
//               hintStyle: TextStyle(
//                 color: colorSoftGrey,
//                 fontSize: 13,
//                 fontWeight: FontWeight.w400,
//                 fontFamily: fontFamilyMain,
//               ),
//               prefixIcon: Padding(
//                 padding: EdgeInsets.only(left: 5, right: 10),
//                 child: Image.asset(
//                   'assets/icons/outlet/search.webp',
//                   width: 20,
//                 ),
//               ),
//               prefixIconConstraints: BoxConstraints(
//                 minWidth: 20,
//                 minHeight: 20,
//               ),
//               suffixIconConstraints: BoxConstraints(
//                 minWidth: 20,
//                 minHeight: 20,
//               ),
//               suffixIcon:
//                   algoliaSearchController.text.isNotEmpty
//                       ? GestureDetector(
//                         onTap: () {
//                           setState(() {
//                             algoliaSearchController.clear();
//                             _tabController!.index = 0;
//                             selectedType = null;
//                           });
//                           textSearchMethod();
//                           algoliaSearch();
//                         },
//                         child: Icon(Icons.clear, color: colorSoftGrey),
//                       )
//                       : Container(
//                         margin: EdgeInsets.only(top: 5),
//                         child: Text(
//                           "Search",
//                           style: TextStyle(
//                             fontSize: 11,
//                             fontWeight: FontWeight.w400,
//                             color: colorTextGrey,
//                           ),
//                         ),
//                       ),
//               border: InputBorder.none,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _algoliaSearchbar(bool? showSuffix) {
//     var width = MediaQuery.of(context).size.width;
//     var filteredSearchHistory =
//         _searchResults.where((element) => element['search'] != '').toList();

//     filteredSearchHistory.sort((a, b) => b['count'].compareTo(a['count']));

//     List<dynamic> topSearches = filteredSearchHistory.take(10).toList();

//     // print('HISTORY TOP SEARCH: $topSearches');

//     return Column(
//       children: <Widget>[
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: 20),
//           child: Row(
//             children: [
//               InkWell(
//                 onTap: () {
//                   Navigator.pop(context);
//                 },
//                 child: Icon(Icons.arrow_back_ios, color: colorBackSearch),
//               ),
//               _searchBar(true),
//               InkWell(
//                 onTap: () {
//                   final scaffoldState = _scaffoldKey.currentState;

//                   if (scaffoldState != null) {
//                     _scaffoldKey.currentState?.openEndDrawer();
//                   }
//                 },
//                 child: Image(
//                   image: AssetImage('assets/icons/search_filter.webp'),
//                   width: width * 0.08,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Container(
//           padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Align(
//                 alignment: Alignment.topLeft,
//                 child: Text(
//                   'History',
//                   style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
//                 ),
//               ),
//               SizedBox(height: 8),
//               Wrap(
//                 spacing: 14, // Space between items horizontally
//                 runSpacing: 5, // Space between items vertically
//                 children: List.generate(topSearches.length, (index) {
//                   final search = topSearches[index];
//                   bool isEqual =
//                       algoliaSearchController.text == search['search'];
//                   return InkWell(
//                     onTap: () {
//                       setState(() {
//                         algoliaSearchController.text = search['search'];
//                       });
//                       textSearchMethod();
//                     },
//                     child: Container(
//                       width: 100,
//                       padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(20),
//                         border: Border.all(
//                           color: isEqual ? colorGoldButton : colorWhiteLow,
//                         ),
//                         color:
//                             isEqual
//                                 ? colorGoldButton
//                                 : colorWhite, // Change background color dynamically
//                       ),
//                       child: Center(
//                         child: Text(
//                           search['search'] ?? '', // Use ?? to handle null
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: isEqual ? colorMulberry : mainColor,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                     ),
//                   );
//                 }),
//               ),
//             ],
//           ),
//         ),
//         // hitsSearchResults(context),
//         Expanded(child: tabs()),
//       ],
//     );
//   }

//   Future<void> getHitsData() async {
//     final hitsSearcher = HitsSearcher(
//       applicationID: 'UGRS8UT0F0',
//       apiKey: 'f65a0dc643e4a91549c0262b4101f693',
//       indexName: 'all_data',
//     )..applyState((state) {
//       return state.copyWith(
//         query: '',
//         facets: ['type'], // Configure on backend
//       );
//     });

//     try {
//       final searchResponse = await hitsSearcher.responses.first;

//       if (searchResponse.facets.isNotEmpty) {
//         var facets = searchResponse.facets['type']!;

//         setState(() {
//           updatedFacets = [
//             Facet(
//               'All',
//               facets.fold<int>(0, (sum, facet) => sum + facet.count),
//             ),
//             ...facets,
//           ];
//           _initializeTabController();
//         });
//       } else {
//         // print("No facets available.");
//       }
//     } catch (error) {
//       // print('Error fetching search results: $error');
//     }
//   }

//   Widget tabs() {
//     return DefaultTabController(
//       length: updatedFacets.length,
//       child: Column(
//         children: [
//           TabBar(
//             controller: _tabController,
//             isScrollable: true,
//             indicatorColor: colorGoldButton,
//             indicatorPadding: EdgeInsets.zero,
//             tabs:
//                 updatedFacets.map((facet) {
//                   return Tab(text: capitalizeFirstLetter(facet.value));
//                 }).toList(),
//             labelColor: mainColor,
//             onTap: (value) {
//               setState(() {
//                 selectedType =
//                     updatedFacets[value].value == 'All'
//                         ? null
//                         : updatedFacets[value].value.toLowerCase();
//               });
//               algoliaSearch();
//             },
//           ),
//           Expanded(
//             child: TabBarView(
//               controller: _tabController,
//               children:
//                   updatedFacets.map((facet) {
//                     return ValueListenableBuilder<bool>(
//                       valueListenable: _isSearching,
//                       builder: (context, isSearching, child) {
//                         if (!isSearching) {
//                           return Center(
//                             child: Text(
//                               'Enter a search term to begin',
//                               style: TextStyle(color: colorGrey),
//                             ),
//                           );
//                         }
//                         return Container(
//                           padding: EdgeInsets.zero,
//                           child: _hits(context),
//                         );
//                       },
//                     );
//                   }).toList(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   /* ------------------ Function for search term query -------------------- */
//   void textSearchMethod() {
//     String query = algoliaSearchController.text;

//     // Apply search state
//     productsSearcher.applyState((state) {
//       return state.copyWith(query: query.isNotEmpty ? query : "", page: 0);
//     });

//     _isSearching.value = true;

//     // Listen for paginated data
//     _searchPage
//         .listen((page) {
//           if (page.pageKey == 0) {
//             _pagingController.refresh();
//           }
//           _pagingController.appendPage(page.items, page.nextPageKey);
//         })
//         .onError((error) {
//           _pagingController.error = error;
//         });

//     // Add listener for page requests
//     _pagingController.addPageRequestListener(
//       (pageKey) =>
//           productsSearcher.applyState((state) => state.copyWith(page: pageKey)),
//     );
//   }

//   /* ------------------ Function for facet/category search -------------------- */
//   void algoliaSearch() {
//     List<String>? facetFilters;
//     if (selectedType != null) {
//       facetFilters = ['type:$selectedType'];
//     } else {
//       facetFilters = ['type:'];
//     }

//     productsSearcher.applyState((state) {
//       return state.copyWith(page: 0, facetFilters: facetFilters);
//     });

//     _isSearching.value = true;

//     // Listen for paginated data
//     _searchPage
//         .listen((page) {
//           if (page.pageKey == 0) {
//             _pagingController.refresh();
//           }

//           _pagingController.appendPage(page.items, page.nextPageKey);
//         })
//         .onError((error) {
//           _pagingController.error = error;
//         });

//     // Add listener for page requests
//     _pagingController.addPageRequestListener(
//       (pageKey) =>
//           productsSearcher.applyState((state) => state.copyWith(page: pageKey)),
//     );
//   }

//   Widget _hits(BuildContext context) => PagedListView<int, Product>(
//     shrinkWrap: true,
//     pagingController: _pagingController,
//     builderDelegate: PagedChildBuilderDelegate<Product>(
//       noItemsFoundIndicatorBuilder:
//           (_) => const Center(
//             child: Text(
//               'No results found',
//               style: TextStyle(fontSize: 11, color: colorGrey),
//             ),
//           ),
//       firstPageProgressIndicatorBuilder: (_) {
//         return _isSearching.value ? LoadingWidget() : SizedBox.shrink();
//       },
//       newPageProgressIndicatorBuilder: (_) {
//         return _isSearching.value ? LoadingWidget() : SizedBox.shrink();
//       },
//       transitionDuration: Duration(milliseconds: 1),
//       itemBuilder: (_, item, __) {
//         var width = MediaQuery.of(context).size.width;

//         return InkWell(
//           onTap: () {
//             item.type == 'voucher'
//                 ? Navigator.of(context).pushNamed(
//                   OderRoutes.rewardDetails,
//                   arguments: RewardDetailsParameters(
//                     rewardId: int.parse(item.id),
//                     title: item.name,
//                     indexPage: 2,
//                   ),
//                 )
//                 : item.type == 'outlet'
//                 ? Navigator.of(context)
//                     .pushNamed(
//                       OderRoutes.outletDetails,
//                       arguments: OutletDetailsParameters(
//                         outletId: int.parse(item.id),
//                         outlet: item.name,
//                       ),
//                     )
//                     .then((value) {})
//                 : item.type == 'merchant'
//                 ? Navigator.of(context)
//                     .pushNamed(
//                       OderRoutes.orderingOutlet,
//                       arguments: OrderingOutletParameters(
//                         brandsId: int.parse(item.id),
//                       ),
//                     )
//                     .then((value) {})
//                 : null;
//           },
//           child: Container(
//             color: colorBackground,
//             height: 80,
//             padding: const EdgeInsets.all(8),
//             child: Row(
//               children: [
//                 SizedBox(
//                   width: 50,
//                   height: 50,
//                   child: CachedImage(imageUrl: item.image),
//                 ),
//                 const SizedBox(width: 10),
//                 Container(
//                   width: width * 0.75,
//                   margin: EdgeInsets.only(top: 10),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Expanded(child: Text(item.name)),
//                       Expanded(
//                         child: Text(
//                           item.description,
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                           style: TextStyle(fontSize: 10, color: colorBlack),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     ),
//   );

//   Widget _emptyListWidget() {
//     return Container(
//       width: ScreenSize.width,
//       color: colorBackground,
//       alignment: Alignment.center,
//       child: Column(
//         children: [
//           Container(
//             height: ScreenSize.height / 12,
//             width: ScreenSize.width * 0.2,
//             margin: EdgeInsets.only(top: ScreenSize.height / 15),
//             padding: EdgeInsets.symmetric(
//               vertical: ScreenSize.height / 8,
//               horizontal: ScreenSize.width,
//             ),
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 fit: BoxFit.contain,
//                 image: AssetImage('assets/icons/empty_brand.webp'),
//                 colorFilter: ColorFilter.mode(
//                   colorBlack.withValues(alpha: 0.3),
//                   BlendMode.srcATop,
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(height: ScreenSize.height * 0.03),
//           Text(
//             "No Available Brands or Vouchers",
//             style: TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.w300,
//               color: colorNoVoucherGrey,
//             ),
//             textAlign: TextAlign.center,
//             textScaler: TextScaler.linear(scaleFactor),
//           ),
//         ],
//       ),
//     );
//   }

//   void sessionExpiredLogOut(String error) {
//     showErrorToast('$error\nYou will be logged out.', context);
//     BlocProvider.of<AuthenticationBloc>(context).add(AuthenticationLoggedOut());
//     Navigator.of(context).pushNamedAndRemoveUntil(
//       OderRoutes.login,
//       (Route<dynamic> route) => false,
//     );
//   }

//   /* ------------- To load search history from Algolia analytics api ------------------- */
//   /* ------------- To be implemented with bloc ------------- */
//   Future<List<dynamic>> fetchSearches() async {
//     const String baseUrl =
//         'https://analytics.de.algolia.com/2/searches?index=all_data';
//     final headers = {
//       'x-algolia-application-id': 'UGRS8UT0F0',
//       'x-algolia-api-key': 'fda6023a1ba03e747349845337827936',
//       'Content-Type': 'application/json',
//     };

//     setState(() {
//       _isHistoryLoading.value = true;
//     });

//     try {
//       final response = await http.get(Uri.parse(baseUrl), headers: headers);

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         setState(() {
//           _searchResults = data['searches'];
//           _isHistoryLoading.value = false;
//         });

//         return data['searches'] ?? [];
//       } else {
//         throw Exception('Failed to load searches: ${response.statusCode}');
//       }
//     } catch (error) {
//       return [];
//     }
//   }

//   /* ---------------- Category filter drawer ---------------- */
//   Widget buildDrawer(
//     BuildContext context,
//     double height,
//     double width,
//     String? gotFilterBy,
//     String? gotFilterValue,
//   ) {
//     return BlocProvider(
//       create:
//           (context) => RewardBloc(
//             context: context,
//             rewardRepository: sl<RewardRepository>(),
//           )..add(FilterCategoryLoad()),
//       child: BlocBuilder<RewardBloc, RewardState>(
//         builder: (context, state) {
//           if (state is FilterCategoryLoaded) {
//             final filterData = state.filterData;

//             return Drawer(
//               width: width * 0.6,
//               backgroundColor: colorBackground,
//               child: Container(
//                 padding: EdgeInsets.symmetric(horizontal: marginHorizontal),
//                 child: ListView(
//                   padding: EdgeInsets.zero,
//                   children: [
//                     DrawerHeader(
//                       padding: EdgeInsets.fromLTRB(0, 16, 0, 8),
//                       child: SizedBox(
//                         height: height,
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Expanded(
//                               child: Container(
//                                 height: height * 0.08,
//                                 alignment: Alignment.center,
//                                 child: Text(
//                                   filterData.title!,
//                                   style: TextStyle(
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.w700,
//                                     fontFamily: fontFamilyMain,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             selectedCategory == null
//                                 ? Container()
//                                 : Expanded(
//                                   child: InkWell(
//                                     highlightColor: colorBackground,
//                                     child: Container(
//                                       margin: EdgeInsets.symmetric(
//                                         vertical: 17,
//                                       ),
//                                       decoration: BoxDecoration(
//                                         border: Border.all(
//                                           color: colorSoftGrey,
//                                         ),
//                                         borderRadius: BorderRadius.circular(5),
//                                       ),
//                                       alignment: Alignment.center,
//                                       child: Text(
//                                         'CLEAR FILTERING',
//                                         style: TextStyle(
//                                           fontSize: 12,
//                                           fontWeight: FontWeight.w600,
//                                           fontFamily: fontFamilyMain,
//                                         ),
//                                       ),
//                                     ),
//                                     onTap: () {
//                                       selectedCategory = null;
//                                       updatedFilterBy = 'all';
//                                       updatedFilterValue = '1';
//                                       Navigator.pop(context);
//                                     },
//                                   ),
//                                 ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     Container(
//                       height: height * 0.7,
//                       color: colorBackground,
//                       child: ListView.builder(
//                         itemCount: filterData.options!.length,
//                         itemBuilder: (context, index) {
//                           return InkWell(
//                             child: Container(
//                               padding: EdgeInsets.only(bottom: 20),
//                               child: Row(
//                                 children: [
//                                   Container(
//                                     width: width * 0.07,
//                                     margin: EdgeInsets.only(right: 8),
//                                     child: Image(
//                                       image: NetworkImage(
//                                         filterData.options![index].image!,
//                                       ),
//                                     ),
//                                   ),
//                                   Text(
//                                     filterData.options![index].name!,
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w500,
//                                       fontFamily: fontFamilyMain,
//                                       color:
//                                           selectedCategory ==
//                                                   filterData.options![index].id
//                                               ? colorMulberry
//                                               : colorBlack,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             onTap: () {
//                               selectedCategory = filterData.options![index].id;
//                               updatedFilterBy =
//                                   filterData.options![index].filterBy!;
//                               updatedFilterValue =
//                                   filterData.options![index].id!.toString();

//                               Navigator.of(context).pushNamed(
//                                 OderRoutes.voucher,
//                                 arguments: VoucherParameters(
//                                   selectedTab: 0,
//                                   filterBy: updatedFilterBy,
//                                   filterValue: updatedFilterValue,
//                                 ),
//                               );
//                             },
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           } else {
//             return Drawer(
//               width: width * 0.6,
//               child: Center(
//                 child: Text(
//                   "Loading filters...",
//                   style: TextStyle(
//                     fontFamily: fontFamilyMain,
//                     color: colorSoftGrey,
//                     fontSize: 10,
//                   ),
//                 ),
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
// }

// class SearchMetadata {
//   final int nbHits;

//   const SearchMetadata(this.nbHits);

//   factory SearchMetadata.fromResponse(SearchResponse response) =>
//       SearchMetadata(response.nbHits);
// }

// class Product {
//   final String name;
//   final String image;
//   final String id;
//   final String type;
//   final String isMuslim;
//   final String muslimCategory;
//   final String description;
//   final String category;
//   final String? tags;
//   final String featured;
//   final String addStates;

//   Product({
//     required this.name,
//     required this.image,
//     required this.id,
//     required this.type,
//     required this.isMuslim,
//     required this.muslimCategory,
//     required this.description,
//     required this.category,
//     this.tags,
//     required this.featured,
//     required this.addStates,
//   });

//   // Factory method to create a Product from JSON
//   factory Product.fromJson(Map<String, dynamic> json) {
//     return Product(
//       name: json['name'] ?? '',
//       image:
//           json['image'] != null && json['image'].isNotEmpty
//               ? json['image']
//               : '',
//       id: json['id'] ?? '',
//       type: json['type'] ?? '',
//       isMuslim: json['isMuslim'] ?? '',
//       muslimCategory: json['muslimCategory'] ?? '',
//       description: json['description'] ?? '',
//       category: json['category'] ?? '',
//       tags: json['tags'] ?? '',
//       featured: json['type'] ?? '',
//       addStates: json['add_states'] ?? '',
//     );
//   }
// }

// class HitsPage {
//   const HitsPage(this.items, this.pageKey, this.nextPageKey);

//   final List<Product> items;
//   final int pageKey;
//   final int? nextPageKey;

//   factory HitsPage.fromResponse(SearchResponse response) {
//     final items = response.hits.map(Product.fromJson).toList();
//     final isLastPage = response.page >= response.nbPages;
//     final nextPageKey = isLastPage ? null : response.page + 1;
//     return HitsPage(items, response.page, nextPageKey);
//   }
// }
