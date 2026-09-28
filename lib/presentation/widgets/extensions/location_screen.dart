import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../app_setting/app_setting.dart';
import '../../../data/data.dart';
import '../../features/rewards/reward.dart';
import '../../widgets/extensions/reward_outlet_view.dart';
import '../widgets.dart';

/* Extension class for location screen(new screen). Will use in features/rewards/view/details.dart &
features/subscription/view/subscription_detail_view.dart & features/voucher/view/voucher_desc.dart */
class LocationScreenParameters {
  final List<RewardOutlet> locationDetails;

  const LocationScreenParameters({required this.locationDetails});
}

class LocationScreen extends StatefulWidget {
  final LocationScreenParameters parameters;

  const LocationScreen({super.key, required this.parameters});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  // List<RewardOutlet> outlets = [];
  List<RewardOutlet> outletDisplay = [];
  TextEditingController editingController = TextEditingController();
  late Future _future;

  @override
  void initState() {
    super.initState();
    _future = Future.delayed(Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return OderScaffold(
      systemUiOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: colorWhiteGrey,
        statusBarIconBrightness: Brightness.dark,
      ),
      appBarColor: colorWhiteGrey,
      title: Text(
        'Outlet(s)',
        style: TextStyle(
          fontFamily: fontFamilyMain,
          color: colorBlack,
          fontWeight: FontWeight.w400,
          fontSize: 15,
        ),
        textScaler: TextScaler.linear(scaleFactor),
      ),
      body: FutureBuilder(
        future: _future, //Future.delayed(Duration(seconds: 1)),
        builder: (context, snapshot) {
          // Checks whether the future is resolved, ie the duration is over
          if (snapshot.connectionState == ConnectionState.done) {
            // outlets = widget.parameters.locationDetails;

            return SingleChildScrollView(
              child: Container(
                // margin: EdgeInsets.symmetric(horizontal: marginHorizontal),
                child:
                    widget.parameters.locationDetails.isEmpty
                        ? Center(
                          child: Container(
                            color: colorBackground,
                            height: ScreenSize.height * 0.7,
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
                                        'assets/icons/no_location.webp',
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: ScreenSize.height * 0.03),
                                Text(
                                  "No Outlet(s) Yet",
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
                        : Column(
                          children: [
                            Container(
                              color: colorWhiteGrey,
                              // height: height * 0.2,
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: marginHorizontal,
                                ),
                                child: _searchBar(),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: marginHorizontal,
                              ),
                              child: listOutletDialog(
                                context,
                                widget.parameters.locationDetails,
                              ),
                            ),
                          ],
                        ),
              ),
            );
          } else {
            // Return loading container to avoid build errors
            return LoadingWidget();
            // return LoadingCustomizationOutlet();
          }
        },
      ),
      bottomMenuIndex: 1,
    );
  }

  // Widget for search function
  Widget _searchBar() {
    var width = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: colorWhite,
        border: Border.all(color: colorGreyBox),
        borderRadius: BorderRadius.circular(5),
      ),
      child: TextField(
        controller: editingController,
        style: TextStyle(
          color: colorBlack,
          fontSize: 15,
          fontWeight: FontWeight.w300,
        ),
        decoration: InputDecoration(
          hintText: "Search",
          hintStyle: TextStyle(
            color: colorSoftGrey,
            fontSize: 13,
            fontWeight: FontWeight.w400,
            fontFamily: fontFamilyMain,
          ),
          icon: SizedBox(
            width: width * 0.05,
            child: Image(image: AssetImage('assets/icons/outlet/search.webp')),
          ),
          border: InputBorder.none,
        ),
        onChanged: searchBrands,
      ),
    );
  }

  Widget listOutletDialog(BuildContext context, List<RewardOutlet> outletList) {
    // outlets = outletList;

    var rewardOutletTiles = widget.parameters.locationDetails
        .map(
          (voucherOutlet) => voucherOutlet.getRewardOutletTile(
            context: context,
            onTap: () {
              Storage().distance = double.parse(
                voucherOutlet.distance!,
              ).toStringAsFixed(2);
              Navigator.of(context).pushNamed(
                OderRoutes.rewardOutletDetails,
                arguments: RewardOutletDetailsParameters(
                  outletId: voucherOutlet.id!,
                  outletName: voucherOutlet.place!,
                ),
              );
            },
          ),
        )
        .toList(growable: false);

    var searchOutletTiles = outletDisplay
        .map(
          (outlet) => outlet.getRewardOutletTile(
            context: context,
            onTap: () {
              Storage().distance = double.parse(
                outlet.distance!,
              ).toStringAsFixed(2);
              Navigator.of(context).pushNamed(
                OderRoutes.rewardOutletDetails,
                arguments: RewardOutletDetailsParameters(
                  outletId: outlet.id!,
                  outletName: outlet.place!,
                ),
              );
            },
          ),
        )
        .toList(growable: false);

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      // controller: _controllerVoucher,
      itemCount:
          editingController.text.isEmpty
              ? widget.parameters.locationDetails.length
              : outletDisplay.length,
      // separatorBuilder: (BuildContext context, int index) {
      //   return Divider(
      //     color: colorBlack,
      //     thickness: 1,
      //     height: 2,
      //     indent: 5,
      //     endIndent: 5,
      //   );
      // },
      itemBuilder: (context, index) {
        return outletDisplay.isEmpty
            ? rewardOutletTiles[index]
            : searchOutletTiles[index];
      },
    );
  }

  // This function is called whenever the text field changes
  searchBrands(String text) {
    text = text.toLowerCase();

    setState(() {
      outletDisplay =
          widget.parameters.locationDetails.where((outlet) {
            var outletPlace = outlet.place!.toLowerCase();
            // var outletAddress = outlet.address!.toLowerCase();
            return outletPlace.contains(
              text,
            ); // || outletAddress.contains(text);
          }).toList();
    });
  }
}
