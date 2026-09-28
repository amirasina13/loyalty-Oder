import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../app_setting/app_setting.dart';
import '../../widgets/widgets.dart';
import '../maintenance/maintenance_screen.dart';
import '../profile/profile.dart';
import '../wrapper.dart';
import 'bulletin.dart';

class BulletinDetailsParameters {
  final String bulletinId;
  final String title;

  const BulletinDetailsParameters({
    required this.bulletinId,
    required this.title,
  });
}

class BulletinDetailsScreen extends StatefulWidget {
  final BulletinDetailsParameters parameters;

  const BulletinDetailsScreen({super.key, required this.parameters});

  @override
  State<BulletinDetailsScreen> createState() => _BulletinDetailsScreenState();
}

class _BulletinDetailsScreenState extends State<BulletinDetailsScreen> {
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
        /* ----------------------------------------------------------------------- Bulletin details appbar */
        return OderScaffold(
          title: Text(
            widget.parameters.title,
            style: TextStyle(
              fontFamily: fontFamilyMain,
              color: colorBlack,
              fontWeight: FontWeight.w400,
              fontSize: 15,
              overflow: TextOverflow.ellipsis,
            ),
            textScaler: TextScaler.linear(scaleFactor),
          ),
          body: BlocProvider<BulletinBloc>(
            create: (context) {
              /* --------------------------------------------------------------- Call BulletinDetailsLoad() event in BulletinBloc to get the details from API */
              return BulletinBloc()..add(
                BulletinDetailsLoad(bulletinId: (widget.parameters.bulletinId)),
              );
            },
            child: BulletinDetailsWrapper(
              bulletinId: widget.parameters.bulletinId,
            ),
          ),
          bottomMenuIndex: 0,
        );
      },
    );
  }
}

class BulletinDetailsWrapper extends StatefulWidget {
  final String bulletinId;

  const BulletinDetailsWrapper({super.key, required this.bulletinId});

  @override
  OderWrapperState<BulletinDetailsWrapper> createState() =>
  // ignore: no_logic_in_create_state
  _BulletinDetailsWrapperState(bulletinId);
}

class _BulletinDetailsWrapperState
    extends OderWrapperState<BulletinDetailsWrapper> {
  final String bulletinId;

  _BulletinDetailsWrapperState(this.bulletinId);

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    /* ------------------------------------------------------------------------- Bulletins bloc */
    return BlocConsumer<BulletinBloc, BulletinState>(
      listener: (context, state) {
        /* ----------------------------------------------------------------------- Listen to state error, popup error dialog */
        if (state is BulletinError) {
          showErrorToast(state.error, context);
        }
        /* ----------------------------------------------------------------------- Listen to network state error, popup error dialog */
        if (state is BulletinNetworkError) {
          showErrorToast(state.error, context);
          Navigator.pop(context);
        }
        /* ----------------------------------------------------------------------- Listen to session state error, popup error dialog */
        if (state is BulletinSessionError) {
          sessionExpiredLogOut(state.error);
        }
        /* ----------------------------------------------------------------------- Listen to maintenance error, navigate to maintenance page */
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
        /* ----------------------------------------------------------------------- Show content view for bulletin details */
        return getPageView(<Widget>[
          BulletinDetailsView(changeView: changePage, bulletinId: bulletinId),
        ]);
      },
    );
  }
}
