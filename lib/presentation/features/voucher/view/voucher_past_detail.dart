import 'dart:async';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../app_setting/app_setting.dart';
import '../../../../data/data.dart';
import '../../../widgets/widgets.dart';
import '../voucher.dart';

class VoucherPastDetailsView extends StatefulWidget {
  final Function? changeView;
  final String voucherId;
  final String title;

  const VoucherPastDetailsView({
    super.key,
    this.changeView,
    required this.voucherId,
    required this.title,
  });

  @override
  State<VoucherPastDetailsView> createState() => _VoucherPastDetailsViewState();
}

class _VoucherPastDetailsViewState extends State<VoucherPastDetailsView> {
  bool isProcessing = false;
  int initialRating = 0, finalRating = 0;
  String initialValue = '', dateFormate = '';
  late Timer durationLoading;
  late VoucherPastDetails pastDetail;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final TextEditingController ratingTextController = TextEditingController();
  final GlobalKey<OderInputFieldState> ratingTextKey = GlobalKey();

  void setProcessingStatus(bool processing) {
    if (!mounted) return;
    setState(() {
      isProcessing = processing;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future _refreshData() async {
    await Future.delayed(Duration(seconds: 1));
    BlocProvider.of<VoucherBloc>(
      // ignore: use_build_context_synchronously
      context,
    ).add(VoucherPastDetailsLoad(voucherId: widget.voucherId));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.of(context).pushNamedAndRemoveUntil(
          OderRoutes.voucher,
          (Route<dynamic> route) => true,
          arguments: VoucherParameters(
            selectedTab: 2,
            filterBy: 'all',
            filterValue: '1',
          ),
        );
      },
      child: OderScaffold(
        title: Text(
          widget.title,
          style: TextStyle(
            fontFamily: fontFamilyMain,
            color: colorBlack,
            fontWeight: FontWeight.w400,
            fontSize: 15,
            // overflow: TextOverflow.ellipsis,
          ),
          textScaler: TextScaler.linear(scaleFactor),
          textAlign: TextAlign.center,
        ),
        bottomMenuIndex: 3,
        // showBottomNavigator: false,
        body: BlocConsumer<VoucherBloc, VoucherState>(
          listener: (context, state) {
            if (state is VoucherRatingSuccess) {
              showSuccessToast(state.ratingResponse['message'], context);

              Navigator.of(context).pushNamedAndRemoveUntil(
                OderRoutes.voucher,
                (route) => false,
                arguments: VoucherParameters(
                  selectedTab: 2,
                  filterBy: 'all',
                  filterValue: '1',
                ),
              );
            }

            if (state is VoucherRatingFailed) {
              setProcessingStatus(false);
              showErrorToast(state.ratingResponse['message'], context);
            }

            if (state is VoucherError) {
              // BlocProvider.of<VoucherBloc>(context).add(VoucherOutletCheck());
              showErrorToast(state.error, context);

              // Navigator.pop(context);
            }
          },
          builder: (context, state) {
            if (state is VoucherInitial || state is VoucherPastDetailsLoading) {
              return LoadingWidget();
            }

            if (state is VoucherPastDetailsLoaded) {
              pastDetail = state.pastDetails;
              initialValue = pastDetail.comment!;
              initialRating = pastDetail.rating!;

              var formatter = DateFormat(appDateFormat);
              dateFormate = formatter.format(
                DateTime.parse(pastDetail.expiredAt!),
              );
            }

            return RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: _refreshData,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: marginHorizontal,
                ),
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AspectRatio(
                            aspectRatio: 1 / 1,
                            child: Container(
                              decoration: BoxDecoration(
                                color: colorDisableGrey,
                                boxShadow: const [
                                  BoxShadow(
                                    color: colorGreyBox,
                                    blurRadius: 5.0,
                                    offset: Offset(0.0, 5.0),
                                  ),
                                ],
                              ),
                              child: CachedImage(
                                imageUrl: pastDetail.image!,
                                // colorFilter: ColorFilter.mode(
                                //   colorWhite.withOpacity(0.35),
                                //   BlendMode.dstATop,
                                // ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                            child: Text(
                              pastDetail.name!,
                              style: TextStyle(
                                fontFamily: fontFamilyMain,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                                // alignment: Alignment.topLeft,
                                color: colorBackground,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: ScreenSize.height * 0.03,
                                      height: ScreenSize.height * 0.03,
                                      margin: EdgeInsets.only(right: 15),
                                      padding: EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: colorWhite,
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(color: colorRedDark),
                                      ),
                                      child: Image(
                                        image: AssetImage(
                                          'assets/icons/calendar.webp',
                                        ),
                                        color: colorRedDark,
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Expired at',
                                          style: TextStyle(
                                            fontFamily: fontFamilyMain,
                                            fontSize: 10,
                                            color: colorBlack,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          textScaler: TextScaler.linear(
                                            scaleFactor,
                                          ),
                                        ),
                                        Text(
                                          dateFormate,
                                          style: TextStyle(
                                            fontFamily: fontFamilyMain,
                                            fontSize: 10,
                                            color: colorBlack,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          textScaler: TextScaler.linear(
                                            scaleFactor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Divider(color: colorDarkGray),
                          /* --------------------------------------------------- Description title part */
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 15, 0, 16),
                            child: Text(
                              'Description',
                              style: TextStyle(
                                fontSize: 16,
                                color: colorBlack,
                                fontWeight: FontWeight.w700,
                              ),
                              textScaler: TextScaler.linear(scaleFactor),
                            ),
                          ),
                          /* --------------------------------------------------- Description info part(from API) */
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                            padding: EdgeInsets.only(left: 20),
                            alignment: Alignment.topLeft,
                            color: colorWhite,
                            child: Text(
                              pastDetail.desc!,
                              style: TextStyle(
                                fontSize: 14,
                                // color: colorSoftGrey,
                                fontWeight: FontWeight.normal,
                              ),
                              textScaler: TextScaler.linear(scaleFactor),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(2, 30, 2, 20),
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: colorWhiteQrLight,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                DottedBorder(
                                  borderType: BorderType.RRect,
                                  radius: Radius.circular(5),
                                  dashPattern: const [8, 8],
                                  color: colorBlack,
                                  strokeWidth: 2,
                                  child: Container(
                                    padding: EdgeInsets.all(15),
                                    alignment: Alignment.center,
                                    child: Text(
                                      pastDetail.code!,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: fontFamilyMain,
                                        fontWeight: FontWeight.w600,
                                        color: colorBlackTab,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 20),
                                  child: Text(
                                    'This coupon code is for single use only.',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: fontFamilyMain,
                                      fontWeight: FontWeight.w500,
                                      color: colorRedeemGrey,
                                    ),
                                  ),
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
        ),
      ),
    );
  }
}
