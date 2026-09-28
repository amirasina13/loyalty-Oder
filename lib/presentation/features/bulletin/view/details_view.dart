import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../../../../app_setting/app_setting.dart';
import '../../../../util/utils.dart';
import '../../../widgets/widgets.dart';
import '../bulletin.dart';

class BulletinDetailsView extends StatefulWidget {
  final Function? changeView;
  final String bulletinId;

  const BulletinDetailsView({
    super.key,
    this.changeView,
    required this.bulletinId,
  });

  @override
  State<BulletinDetailsView> createState() => _BulletinDetailsViewState();
}

class _BulletinDetailsViewState extends State<BulletinDetailsView> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  Future _refreshData() async {
    await Future.delayed(Duration(seconds: 1));
    BlocProvider.of<BulletinBloc>(
      // ignore: use_build_context_synchronously
      context,
    ).add(BulletinDetailsLoad(bulletinId: widget.bulletinId));
  }

  /* --------------------------------------------------------------------------- Main user interface */
  @override
  Widget build(BuildContext context) {
    /* ------------------------------------------------------------------------- Bulletin bloc. Lisen to bulletin state */
    return BlocConsumer<BulletinBloc, BulletinState>(
      listener: (context, state) {},
      builder: (context, state) {
        /* --------------------------------------------------------------------- if state now is BulletinLoading, will show loading progress indicator */
        if (state is BulletinDetailsLoading) {
          return LoadingWidget();
        }
        /* --------------------------------------------------------------------- if state now is BulletinDetailsLoaded, */
        if (state is BulletinDetailsLoaded) {
          /* decalre the detail and bulletinId */
          var detail = state.details;
          var bulletinId = detail.id;

          /* ------------------------------------------------------------------- if bulletin got value, show design */
          if (bulletinId != null) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: marginHorizontal),
              child: RefreshIndicator(
                key: _refreshIndicatorKey,
                onRefresh: _refreshData,
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          Container(
                            color: colorWhite,
                            child: Container(
                              color: colorWhite,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  /* Container for bulletin detail.image */
                                  Container(
                                    color: colorTransparent,
                                    width: double.infinity,
                                    margin: EdgeInsets.only(bottom: 20),
                                    child: Align(
                                      alignment: Alignment.topCenter,
                                      child: AspectRatio(
                                        aspectRatio: 2 / 1,
                                        child: CachedImage(
                                          imageUrl: detail.image!,
                                        ),
                                      ),
                                    ),
                                  ),
                                  /* Container for detail.content in Html */
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 20),
                                    child: HtmlWidget(
                                      detail.content!,
                                      textStyle: TextStyle(
                                        fontSize: 12,
                                        // color: colorReferGrey,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      // customWidgetBuilder: (element) {
                                      //   if (element.localName == 'span') {
                                      //     return Text(
                                      //       element.text,
                                      //       style: TextStyle(
                                      //         fontFamily: fontFamilyMain,
                                      //         fontSize: 14,
                                      //         color: colorSoftGrey,
                                      //       ),
                                      //     );
                                      //   }
                                      //   return null;
                                      // },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    /* This part if details got button, show the button
                           else showing empty container */
                    detail.isButton == true
                        ? SliverFillRemaining(
                          hasScrollBody: false,
                          child: Container(
                            height: ScreenSize.height / 14,
                            alignment: Alignment.bottomCenter,
                            margin: EdgeInsets.only(bottom: 10),
                            child: OderStyleButton(
                              title: detail.button!,
                              height: ScreenSize.height / 14,
                              backgroundColor: mainColor,
                              textColor: colorWhite,
                              onPressed:
                                  (() => {
                                    Navigator.push(
                                      context,
                                      NoAnimationPageRoute(
                                        builder: (context) {
                                          // Directly return WidgetWebView, as it contains its own Scaffold and AppBar
                                          return WidgetWebView(
                                            widgetUrl: detail.link!,
                                            title: detail.name!,
                                          );
                                        },
                                      ),
                                    ),
                                  }), //() => openLink(detail.link!),
                            ),
                          ),
                        )
                        : SliverFillRemaining(
                          hasScrollBody: false,
                          child: Container(),
                        ),
                  ],
                ),
              ),
            );
          }
        }
        /* --------------------------------------------------------------------- if no bulletin details calling will show empty container */
        return Container();
      },
    );
  }
}
