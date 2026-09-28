import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../app_setting/app_setting.dart';
import '../../../../data/data.dart';
import '../../../widgets/extensions/credit_history_view.dart';
import '../../../widgets/extensions/history_view.dart';
import '../../../widgets/widgets.dart';
import '../../authentication/authentication.dart';
import '../../history/history.dart';
import '../../maintenance/maintenance_screen.dart';
import '../../profile/profile.dart';

class HistoryView extends StatefulWidget {
  final Function changeView;
  final int selectedTab;
  const HistoryView({
    super.key,
    required this.changeView,
    required this.selectedTab,
  });

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  History? history;
  CreditHistory? creditHistory;
  late HistoryBloc historyBloc;
  var transactionHistoryTiles = [];
  var creditTransactionHistoryTiles = [];
  List<Records> records = <Records>[];
  List<CreditRecords> creditRecords = <CreditRecords>[];
  bool isLoading = false;
  bool isCredits = false;
  var totalCredits = '0.00', totalPoints = '0.00';

  @override
  void initState() {
    super.initState();

    fToast = FToast();
    fToast.init(context);

    widget.selectedTab == 0 ? isCredits = true : false;
  }

  @override
  Widget build(BuildContext context) {
    return creditEnable == true &&
            creditHistoryEnable == true &&
            pointEnable == true &&
            pointHistory == true
        ? Container(
          color: colorBackground,
          // height: MediaQuery.of(context).size.height - // total height
          //     kToolbarHeight - // top AppBar height
          //     MediaQuery.of(context).padding.top - // top padding
          //     kBottomNavigationBarHeight, // BottomNavigationBar height
          margin: EdgeInsets.symmetric(
            horizontal: marginHorizontal,
            vertical: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocConsumer<ProfileBloc, ProfileState>(
                listener: (context, state) {
                  if (state is ProfileLoaded) {
                    double? numericCredit = double.tryParse(
                      state.userProfile.profile!.credits.toString(),
                    );
                    double? numericPoint = double.tryParse(
                      state.userProfile.profile!.points.toString(),
                    );
                    String formattedCredit = (numericCredit ?? 0.0)
                        .toStringAsFixed(2);
                    String formattedPoint = (numericPoint ?? 0.0)
                        .toStringAsFixed(2);

                    totalCredits = formattedCredit;
                    totalPoints = formattedPoint;
                  }
                },
                builder: (context, state) {
                  return Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isCredits ? colorRedDark : colorGreyBox,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: isCredits ? colorRedDark : colorBackground,
                          ),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                isCredits = true;
                                creditRecords.clear();
                                BlocProvider.of<HistoryBloc>(
                                  context,
                                ).add(CreditHistoryTransactionsLoad());
                                BlocProvider.of<HistoryBloc>(context)
                                    .isFirstShow = true;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: ScreenSize.height * 0.035,
                                    margin: EdgeInsets.only(bottom: 5),
                                    child: Image(
                                      image: AssetImage(
                                        'assets/icons/settings/txn-money.webp',
                                      ),
                                      color:
                                          isCredits
                                              ? colorGoldButton
                                              : colorHistGrey,
                                    ),
                                  ),
                                  Text(
                                    totalCredits,
                                    style: TextStyle(
                                      fontFamily: fontFamilyMain,
                                      fontSize: 32,
                                      color:
                                          isCredits
                                              ? colorGoldButton
                                              : colorHistGrey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textScaler: TextScaler.linear(scaleFactor),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text(
                                      '$creditLabelTitle Balance',
                                      style: TextStyle(
                                        fontFamily: fontFamilyMain,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                        color:
                                            isCredits
                                                ? colorGoldButton
                                                : colorHistGrey,
                                      ),
                                      textAlign: TextAlign.center,
                                      textScaler: TextScaler.linear(
                                        scaleFactor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: ScreenSize.width * 0.03),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color:
                                  !isCredits ? colorGoldButton : colorGreyBox,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color:
                                !isCredits ? colorGoldButton : colorBackground,
                          ),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                isCredits = false;
                                records.clear();
                                BlocProvider.of<HistoryBloc>(
                                  context,
                                ).add(HistoryTransactionsLoad());
                                BlocProvider.of<HistoryBloc>(context)
                                    .isFirstShowPoint = true;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: ScreenSize.height * 0.035,
                                    margin: EdgeInsets.only(bottom: 5),
                                    child: Image(
                                      image: AssetImage(
                                        'assets/icons/settings/txn-coin.webp',
                                      ),
                                      color:
                                          !isCredits
                                              ? colorRedDark
                                              : colorHistGrey,
                                    ),
                                  ),
                                  Text(
                                    totalPoints,
                                    style: TextStyle(
                                      fontFamily: fontFamilyMain,
                                      fontSize: 32,
                                      color:
                                          !isCredits
                                              ? colorRedDark
                                              : colorHistGrey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textScaler: TextScaler.linear(scaleFactor),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text(
                                      '$pointLabelTitle Available',
                                      style: TextStyle(
                                        fontFamily: fontFamilyMain,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                        color:
                                            !isCredits
                                                ? colorRedDark
                                                : colorHistGrey,
                                      ),
                                      textAlign: TextAlign.center,
                                      textScaler: TextScaler.linear(
                                        scaleFactor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  isCredits ? creditLabelTitle : pointLabelTitle,
                  style: TextStyle(
                    fontFamily: fontFamilyMain,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Divider(height: 1, thickness: 1, color: colorGrey),
              isCredits
                  ? Expanded(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.68,
                      color: colorWhite,
                      child: BlocConsumer<HistoryBloc, HistoryState>(
                        listener: (context, state) {},
                        builder: (context, state) {
                          return _buildTabCredit(context);
                        },
                      ),
                    ),
                  )
                  : Expanded(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.68,
                      color: colorWhite,
                      child: BlocConsumer<HistoryBloc, HistoryState>(
                        listener: (context, state) {},
                        builder: (context, state) {
                          return _buildHistory(context);
                        },
                      ),
                    ),
                  ),
            ],
          ),
        )
        : Container(
          color: colorBackground,
          height: ScreenSize.height * 0.8,
          margin: EdgeInsets.symmetric(horizontal: marginHorizontal),
          child:
              creditEnable == true && creditHistoryEnable == true
                  ? BlocProvider<HistoryBloc>(
                    create: (context) {
                      creditRecords.clear();
                      return HistoryBloc()
                        ..add(CreditHistoryTransactionsLoad());
                    },
                    child: BlocConsumer<HistoryBloc, HistoryState>(
                      listener: (context, state) {
                        if (state is HistoryError) {
                          showErrorToast(state.error, context);
                          // ErrorDialog.showErrorDialog(
                          //     context, state.error);
                        }
                        if (state is HistorySessionError) {
                          sessionExpiredLogOut(state.error);
                        }
                        /* --------------------------------------------- Listen to maintenance error, navigate to maintenance page */
                        if (state is HistoryMaintenanceError) {
                          Navigator.pushAndRemoveUntil<void>(
                            context,
                            MaterialPageRoute<void>(
                              builder:
                                  (BuildContext context) => MaintenanceScreen(
                                    parameters: MaintenanceParameters(
                                      message: state.message,
                                    ),
                                  ),
                            ),
                            ModalRoute.withName('/'),
                          );
                        }
                      },
                      builder: (context, state) {
                        return _buildTabCredit(context);
                      },
                    ),
                  )
                  : pointEnable == true && pointHistory == true
                  ? BlocProvider<HistoryBloc>(
                    create: (context) {
                      records.clear();
                      return HistoryBloc()..add(HistoryTransactionsLoad());
                    },
                    child: BlocConsumer<HistoryBloc, HistoryState>(
                      listener: (context, state) {
                        if (state is HistoryError) {
                          showErrorToast(state.error, context);
                        }
                        if (state is HistorySessionError) {
                          sessionExpiredLogOut(state.error);
                        }
                        /* --------------------------------------------- Listen to maintenance error, navigate to maintenance page */
                        if (state is HistoryMaintenanceError) {
                          Navigator.pushAndRemoveUntil<void>(
                            context,
                            MaterialPageRoute<void>(
                              builder:
                                  (BuildContext context) => MaintenanceScreen(
                                    parameters: MaintenanceParameters(
                                      message: state.message,
                                    ),
                                  ),
                            ),
                            ModalRoute.withName('/'),
                          );
                        }
                      },
                      builder: (context, state) {
                        return _buildHistory(context);
                      },
                    ),
                  )
                  : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: ScreenSize.height / 12,
                          width: ScreenSize.width * 0.2,
                          padding: EdgeInsets.symmetric(
                            vertical: ScreenSize.height / 8,
                            horizontal: ScreenSize.width,
                          ),
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.contain,
                              image: AssetImage(
                                'assets/icons/wallet/no_transaction.webp',
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: ScreenSize.height * 0.03),
                        Text(
                          "No Transaction History yet",
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

  Widget _buildHistory(BuildContext context) {
    return BlocConsumer<HistoryBloc, HistoryState>(
      listener: ((context, state) {
        if (state is HistoryListStop) {
          showPaginationToast('No more transaction', context);
        }
      }),
      builder: (context, state) {
        if (state is HistoryLoading) {
          return LoadingWidget();
        }

        if (state is HistoryTransactionsLoaded) {
          // first check if api returns any historical records,
          if (state.history.records != null &&
              state.history.records!.isNotEmpty) {
            // if history.records is neither null or empty
            // append to the global records variable (List<Records>)
            records.addAll(state.history.records!);
            BlocProvider.of<HistoryBloc>(context).isFetching = false;
            BlocProvider.of<HistoryBloc>(context).isFirstShowPoint = false;
          }

          // comment: instead of working with the records from api,
          // records.add(state.history.records);
          // comment: work with the global variable that has the records from API added above
          transactionHistoryTiles = records;
          BlocProvider.of<HistoryBloc>(context).isFetching = false;
          BlocProvider.of<HistoryBloc>(context).isFirstShowPoint = false;
        }
        if (state is HistoryEmpty) {
          return Center(
            child: Container(
              height: ScreenSize.height * 0.3,
              color: colorTransparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: ScreenSize.height / 12,
                    width: ScreenSize.width * 0.2,
                    padding: EdgeInsets.symmetric(
                      vertical: ScreenSize.height / 8,
                      horizontal: ScreenSize.width,
                    ),
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.contain,
                        image: AssetImage(
                          'assets/icons/wallet/no_transaction.webp',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: ScreenSize.height * 0.03),
                  Text(
                    "No Transaction History yet",
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

        return Column(
          children: [
            Expanded(
              child: Container(child: _buildTransactionList(context, state)),
            ),
            state is HistoryPointNextLoading
                ? SizedBox(child: LoadingWidget())
                : Container(),
          ],
        );
      },
    );
  }

  Widget _buildTransactionList(BuildContext context, HistoryState state) {
    if (state is HistoryTransactionsLoaded) {
      history = state.history;
    }

    if (history != null) {
      transactionHistoryTiles = records
          .map(
            (pointList) =>
                pointList.getHistoryTile(context: context, state: state),
          )
          .toList(growable: false);

      ScrollController scrollController = ScrollController();
      scrollController.addListener(() async {
        if (scrollController.position.maxScrollExtent ==
            scrollController.position.pixels) {
          if (!BlocProvider.of<HistoryBloc>(context).isFetching) {
            BlocProvider.of<HistoryBloc>(context)
              ..isFetching = true
              ..add(HistoryTransactionsLoad());
            BlocProvider.of<HistoryBloc>(context).isFirstShowPoint = false;
          }
        }
      });

      return ListView.builder(
        padding: EdgeInsets.only(bottom: 40),
        shrinkWrap: true,
        controller: scrollController,
        itemCount: records.length,
        itemBuilder: (BuildContext context, int index) {
          return transactionHistoryTiles[index];
        },
      );
    }

    return Container();
  }

  Widget _buildTabCredit(BuildContext context) {
    return BlocConsumer<HistoryBloc, HistoryState>(
      listener: ((context, state) {
        if (state is CreditHistoryListStop) {
          showPaginationToast('No more transaction', context);
        }
      }),
      builder: (context, state) {
        if (state is HistoryLoading) {
          return LoadingWidget();
        }

        if (state is CreditHistoryTransactionsLoaded) {
          // first check if api returns any historical records,
          if (state.history.records != null &&
              state.history.records!.isNotEmpty) {
            // if history.records is neither null or empty
            // append to the global records variable (List<CreditRecords>)
            creditRecords.addAll(state.history.records!);
            BlocProvider.of<HistoryBloc>(context).isCreditFetching = false;
            BlocProvider.of<HistoryBloc>(context).isFirstShow = false;
          }

          // comment: instead of working with the records from api,
          // records.add(state.history.records);
          // comment: work with the global variable that has the records from API added above
          creditTransactionHistoryTiles = creditRecords;
          BlocProvider.of<HistoryBloc>(context).isCreditFetching = false;
          BlocProvider.of<HistoryBloc>(context).isFirstShow = false;
        }

        if (state is CreditHistoryEmpty) {
          return Center(
            child: Container(
              height: ScreenSize.height * 0.3,
              color: colorTransparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: ScreenSize.height / 12,
                    width: ScreenSize.width * 0.2,
                    padding: EdgeInsets.symmetric(
                      vertical: ScreenSize.height / 8,
                      horizontal: ScreenSize.width,
                    ),
                    // margin: EdgeInsets.only(top: height * 0.02),
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.contain,
                        image: AssetImage(
                          'assets/icons/wallet/no_transaction.webp',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: ScreenSize.height * 0.03),
                  Text(
                    "No Transaction History yet",
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

        return Column(
          children: [
            Expanded(
              child: Container(
                child: _buildCreditTransactionList(context, state),
              ),
            ),
            state is HistoryCreditNextLoading
                ? SizedBox(child: LoadingWidget())
                : Container(),
          ],
        );
      },
    );
  }

  Widget _buildCreditTransactionList(BuildContext context, HistoryState state) {
    if (state is CreditHistoryTransactionsLoaded) {
      creditHistory = state.history;
    }

    if (creditHistory != null) {
      creditTransactionHistoryTiles = creditRecords
          .map(
            (creditList) => creditList.getCreditHistoryTile(
              context: context,
              // state: state,
            ),
          )
          .toList(growable: false);

      ScrollController scrollControllerCredit = ScrollController();
      scrollControllerCredit.addListener(() async {
        if (scrollControllerCredit.position.maxScrollExtent ==
            scrollControllerCredit.position.pixels) {
          if (!BlocProvider.of<HistoryBloc>(context).isCreditFetching) {
            BlocProvider.of<HistoryBloc>(context)
              ..isCreditFetching = true
              ..add(CreditHistoryTransactionsLoad());
            BlocProvider.of<HistoryBloc>(context).isFirstShow = false;
          }
        }
      });

      return ListView.builder(
        padding: EdgeInsets.only(bottom: 40),
        shrinkWrap: true,
        controller: scrollControllerCredit,
        itemCount: creditRecords.length,
        itemBuilder: (BuildContext context, int index) {
          return creditTransactionHistoryTiles[index];
        },
      );
    }

    return Container();
  }

  void sessionExpiredLogOut(String error) {
    showErrorToast('$error\nYou will be logged out.', context);
    BlocProvider.of<AuthenticationBloc>(context).add(AuthenticationLoggedOut());
    Navigator.of(context).pushNamedAndRemoveUntil(
      OderRoutes.login,
      (Route<dynamic> route) => false,
    );
  }
}
