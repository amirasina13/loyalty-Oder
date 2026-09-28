// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../app_setting/routes.dart';
import '../widgets/independent/toast_dialog.dart';
import 'authentication/authentication.dart';

enum ViewChangeType { Start, Forward, Backward, Exact }

class OderWrapperState<T> extends State {
  late PageController _viewController;

  PageView getPageView(List<Widget> widgets) {
    return PageView(
      physics: NeverScrollableScrollPhysics(),
      controller: _viewController,
      children: widgets,
    );
  }

  void changePage({required ViewChangeType changeType, int? index}) {
    switch (changeType) {
      case ViewChangeType.Forward:
        _viewController.nextPage(
          duration: Duration(milliseconds: 1),
          curve: Curves.linear,
        );
        break;
      case ViewChangeType.Backward:
        _viewController.previousPage(
          duration: Duration(milliseconds: 300),
          curve: Curves.bounceIn,
        );
        break;
      case ViewChangeType.Start:
        _viewController.jumpToPage(0);
        break;
      case ViewChangeType.Exact:
        _viewController.jumpToPage(index!);
        break;
    }
  }

  @override
  void initState() {
    _viewController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _viewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    throw Exception('Build method should be implemented in child class');
  }

  void sessionExpiredLogOut(String error) {
    setState(() {
      fToast = FToast();
      fToast.init(context);
    });

    showErrorToast('$error\nYou will be logged out.', context);
    BlocProvider.of<AuthenticationBloc>(context).add(AuthenticationLoggedOut());

    Navigator.of(context).pushNamedAndRemoveUntil(
      OderRoutes.login,
      (Route<dynamic> route) => false,
    );
  }
}
