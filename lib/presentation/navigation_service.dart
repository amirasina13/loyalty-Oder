import 'package:flutter/material.dart';
import 'package:navigation_history_observer/navigation_history_observer.dart';

/// Global observer used by RouteAware widgets.
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic>? navigateTo(String routeName) {
    var topRoute = NavigationHistoryObserver().top;
    String? topRouteName;
    if (topRoute != null) {
      topRouteName = topRoute.settings.name;
    }

    if (topRouteName != routeName) {
      return navigatorKey.currentState?.pushNamedAndRemoveUntil(
        routeName,
        (Route<dynamic> route) => false,
      );
    }
    return null;
    // return navigatorKey.currentState?.pushNamed(routeName);
  }
}
