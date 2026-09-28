import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../app_setting/app_setting.dart';
import '../../widgets/widgets.dart';
import '../maintenance/maintenance_screen.dart';
import '../profile/profile.dart';
import '../wrapper.dart';
import 'bulletin.dart';

class BulletinScreen extends StatefulWidget {
  const BulletinScreen({super.key});

  @override
  State<BulletinScreen> createState() => _BulletinScreenState();
}

class _BulletinScreenState extends State<BulletinScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, profileState) {
        /* If processing, show indicator */
        if (profileState is ProfileProcessing) {
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: colorWhite,
            child: LoadingWidget(),
          );
        }
        /* ------------------------------------------------------------------- Bulletin list appbar */
        return OderScaffold(
          title: Text(
            'Highlights',
            style: TextStyle(
              fontFamily: fontFamilyMain,
              color: colorBlack,
              fontWeight: FontWeight.w400,
              fontSize: 15,
            ),
            textScaler: TextScaler.linear(scaleFactor),
          ),
          body: BulletinWrapper(),
          bottomMenuIndex: 0,
        );
      },
    );
  }
}

class BulletinWrapper extends StatefulWidget {
  const BulletinWrapper({super.key});

  @override
  OderWrapperState<BulletinWrapper> createState() => _BulletinWrapperState();
}

class _BulletinWrapperState extends OderWrapperState<BulletinWrapper> {
  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BulletinBloc>(
      create: (context) {
        /* --------------------------------------------------------------------- Call BulletinListLoad() event in BulletinBloc to get bulletin list from API */
        return BulletinBloc()..add(BulletinListLoad(type: 'highlight'));
      },
      /* ----------------------------------------------------------------------- Bulletins bloc */
      child: BlocConsumer<BulletinBloc, BulletinState>(
        listener: (context, state) {
          /* ------------------------------------------------------------------- Listen to state error, popup error dialog */
          if (state is BulletinError) {
            showErrorToast(state.error, context);
          }
          /* ------------------------------------------------------------------- Listen to network state error, popup error dialog */
          if (state is BulletinNetworkError) {
            showErrorToast(state.error, context);
            Navigator.pop(context);
          }
          /* ------------------------------------------------------------------- Listen to session state error, popup error dialog */
          if (state is BulletinSessionError) {
            sessionExpiredLogOut(state.error);
          }
          /* ------------------------------------------------------------------- Listen to maintenance error, navigate to maintenance page */
          if (state is BulletinMaintenanceError) {
            Navigator.pushAndRemoveUntil<void>(
              context,
              MaterialPageRoute<void>(
                builder:
                    (BuildContext context) => MaintenanceScreen(
                      parameters: MaintenanceParameters(message: state.message),
                    ),
              ),
              ModalRoute.withName('/'),
            );
          }
        },
        builder: (context, state) {
          /* ------------------------------------------------------------------- Show content view for bulletin details */
          return getPageView(<Widget>[BulletinView(changeView: changePage)]);
        },
      ),
    );
  }
}
