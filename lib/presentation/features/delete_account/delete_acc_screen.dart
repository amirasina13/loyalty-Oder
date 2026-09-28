import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../app_setting/app_setting.dart';
import '../../../locator.dart';
import '../../widgets/widgets.dart';
import '../profile/profile.dart';
import '../wrapper.dart';
import 'delete_acc.dart';

class DeleteAccScreen extends StatefulWidget {
  const DeleteAccScreen({super.key});

  @override
  State<DeleteAccScreen> createState() => _DeleteAccScreenState();
}

class _DeleteAccScreenState extends State<DeleteAccScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileProcessing) {
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: colorWhite,
            child: LoadingWidget(),
          );
        }
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: OderScaffold(
            title: Text(
              'Delete My Account',
              style: TextStyle(
                fontFamily: fontFamilyMain,
                color: colorBlack,
                fontWeight: FontWeight.w400,
                fontSize: 15,
              ),
              textScaler: TextScaler.linear(scaleFactor),
            ),
            body: DeleteAccWrapper(),
            bottomMenuIndex: 4,
            showBottomNavigator: false,
          ),
        );
      },
    );
  }
}

class DeleteAccWrapper extends StatefulWidget {
  const DeleteAccWrapper({super.key});

  @override
  OderWrapperState<DeleteAccWrapper> createState() => _DeleteAccWrapperState();
}

class _DeleteAccWrapperState extends OderWrapperState<DeleteAccWrapper> {
  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DeleteAccBloc>(
      create: (context) {
        return DeleteAccBloc(userRepository: sl());
      },
      child: BlocConsumer<DeleteAccBloc, DeleteAccState>(
        listener: (context, state) {
          if (state is DeleteAccError) {
            // ErrorDialog.showErrorDialog(context, state.error);
            showErrorToast(state.error, context);
          }
        },
        builder: (context, state) {
          return getPageView(<Widget>[ReasonView(changeView: changePage)]);
        },
      ),
    );
  }
}
