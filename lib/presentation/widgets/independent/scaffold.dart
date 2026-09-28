import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../app_setting/app_setting.dart';
import 'bottom_menu.dart';

/* Widget class for custom scaffold. */
class OderScaffold extends StatelessWidget {
  final Color? background;
  final Widget? leading;
  final Widget? title;
  final double? elevation;
  final Widget body;
  final int bottomMenuIndex;
  final List<String>? tabBarList;
  final TabController? tabController;
  final Color? appBarColor;
  final FloatingActionButton? actionButton;
  final bool extendBodyBehindAppBar;
  final bool isShow;
  final List<Widget>? appbarAction;
  final bool? showAppbar;
  final bool canClick;
  final bool isCenterTitle;
  final bool? showBottomNavigator;
  final Widget? endDrawer;
  final bool endDrawerEnableOpenDragGesture;
  final Key? scaffoldKey;
  final SystemUiOverlayStyle? systemUiOverlayStyle;

  const OderScaffold({
    super.key,
    this.background = colorBackground,
    this.leading,
    this.title,
    this.elevation = 0.0,
    required this.body,
    required this.bottomMenuIndex,
    this.tabBarList,
    this.tabController,
    this.appBarColor = colorBackground,
    this.actionButton,
    this.extendBodyBehindAppBar = false,
    this.isShow = false,
    this.appbarAction,
    this.showAppbar = true,
    this.canClick = true,
    this.isCenterTitle = true,
    this.showBottomNavigator = true,
    this.endDrawer,
    this.endDrawerEnableOpenDragGesture = false,
    this.scaffoldKey,
    this.systemUiOverlayStyle,
  });

  @override
  Widget build(BuildContext context) {
    var tabBars = <Tab>[];
    var theme = Theme.of(context);
    if (tabBarList != null) {
      for (var i = 0; i < tabBarList!.length; i++) {
        tabBars.add(Tab(key: UniqueKey(), text: tabBarList![i]));
      }
    }

    // ignore: prefer_typing_uninitialized_variables
    var tabWidget;
    if (tabBars.isNotEmpty) {
      tabWidget = TabBar(
        unselectedLabelColor: theme.primaryColor,
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.normal,
          fontFamily: fontFamilyMain,
        ),
        labelColor: theme.primaryColor,
        labelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: fontFamilyMain,
        ),
        tabs: tabBars,
        controller: tabController,
        indicatorColor: theme.colorScheme.secondary,
        indicatorSize: TabBarIndicatorSize.tab,
      );
    }
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: background,
        extendBodyBehindAppBar: extendBodyBehindAppBar,
        endDrawerEnableOpenDragGesture: endDrawerEnableOpenDragGesture,
        appBar:
            showAppbar == true
                ? AppBar(
                  elevation: elevation,
                  iconTheme: IconThemeData(color: colorBlack),
                  leading: leading,
                  title: title,
                  actions: appbarAction,
                  centerTitle: isCenterTitle,
                  bottom: tabWidget,
                  backgroundColor: appBarColor,
                  foregroundColor: colorWhite,
                  systemOverlayStyle: systemUiOverlayStyle,
                )
                : null,
        body: body,
        bottomNavigationBar:
            showBottomNavigator == true
                ? OderBottomMenu(bottomMenuIndex, isShow, canClick)
                : null,
        resizeToAvoidBottomInset: true,
        floatingActionButton: actionButton,
        endDrawer: endDrawer,
      ),
    );
  }
}
