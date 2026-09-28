import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../../app_setting/app_setting.dart';
import '../../../../../data/data.dart';
import '../../../../widgets/extensions/voucher_past_view.dart';
import '../../../../widgets/widgets.dart';
import '../../voucher.dart';

class MyVoucherPastTab extends StatefulWidget {
  const MyVoucherPastTab({super.key});

  @override
  State<MyVoucherPastTab> createState() => _MyVoucherPastTabState();
}

class _MyVoucherPastTabState extends State<MyVoucherPastTab>
    with TickerProviderStateMixin {
  List<VoucherPast> vouchersPast = [];
  // final bool _enabled = true;

  /* --------------------------------------------------------------------------- initState - Called when this object is inserted into the tree */
  @override
  void initState() {
    super.initState();

    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<VoucherBloc>(
      create: (context) {
        // creditRecords.clear();
        return VoucherBloc()..add(VoucherPastTransactionsLoad());
      },
      child: BlocConsumer<VoucherBloc, VoucherState>(
        listener: (context, state) {},
        builder: (context, state) {
          return SingleChildScrollView(
            child: Container(
              // height: height * 0.8,
              color: colorBackground,
              margin: EdgeInsets.symmetric(
                horizontal: marginHorizontal,
                vertical: 0,
              ),
              padding: EdgeInsets.only(bottom: 15),
              child: BlocConsumer<VoucherBloc, VoucherState>(
                listener: (context, state) {},
                builder: (context, state) {
                  if (state is VoucherLoading) {
                    return Container(
                      margin: EdgeInsets.only(top: ScreenSize.height * 0.343),
                      // color: colorBabyBlue,
                      child: LoadingWidget(),
                    );
                  }
                  if (state is VoucherEmpty) {
                    return Center(
                      child: Container(
                        // margin: EdgeInsets.only(top: height * 0.2),
                        color: colorBackground,
                        height: ScreenSize.height * 0.65,
                        padding: EdgeInsets.only(top: ScreenSize.height * 0.11),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: ScreenSize.width * 0.18,
                              width: ScreenSize.width * 0.18,
                              // margin: EdgeInsets.only(top: height / 4),
                              padding: EdgeInsets.symmetric(
                                vertical: ScreenSize.height / 8,
                                horizontal: ScreenSize.width,
                              ),
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.contain,
                                  image: AssetImage(
                                    'assets/icons/no_deals.webp',
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
                    );
                  }

                  return _buildVoucherPastListView(context, state);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVoucherPastListView(BuildContext context, VoucherState state) {
    if (state is VoucherPastTransactionsLoaded) {
      vouchersPast = state.vouchersPast;
    }

    var voucherPastTiles = vouchersPast
        .map(
          (voucher) => voucher.getVoucherPastTile(
            context: context,
            past: true,
            onTap: () {
              Navigator.of(context).pushNamed(
                OderRoutes.voucherPastDetails,
                arguments: VoucherPastDetailsParameters(
                  voucherId: voucher.id!,
                  title: voucher.name!,
                ),
              );
            },
            ontapRate: () {
              Navigator.of(context).pushNamed(
                OderRoutes.voucherfeedback,
                arguments: VoucherFeedbackParameters(voucherId: voucher.id!),
              );
            },
          ),
        )
        .toList(growable: false);

    return vouchersPast.isNotEmpty
        ? ListView.builder(
          shrinkWrap: true,
          itemCount: vouchersPast.length,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(
            top: 10,
            bottom: Platform.isIOS ? 80 : ScreenSize.height * 0.1,
          ),
          itemBuilder: (context, index) {
            return voucherPastTiles[index];
          },
        )
        : Center(
          child: Container(
            // margin: EdgeInsets.only(top: height * 0.2),
            color: colorBackground,
            height: ScreenSize.height * 0.65,
            padding: EdgeInsets.only(top: ScreenSize.height * 0.11),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: ScreenSize.width * 0.18,
                  width: ScreenSize.width * 0.18,
                  // margin: EdgeInsets.only(top: height / 4),
                  padding: EdgeInsets.symmetric(
                    vertical: ScreenSize.height / 8,
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
        );
  }
}
