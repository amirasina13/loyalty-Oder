import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../app_setting/app_setting.dart';
import '../../../locator.dart';
import '../../widgets/widgets.dart';
import '../maintenance/maintenance_screen.dart';
import '../profile/profile.dart';
import '../wrapper.dart';
import 'home.dart';

class SearchScreenParameters {
  final String? tabFor;

  const SearchScreenParameters({required this.tabFor});
}

class SearchScreen extends StatefulWidget {
  final SearchScreenParameters parameters;

  const SearchScreen({super.key, required this.parameters});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
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
        return SearchWrapper(tabFor: widget.parameters.tabFor!);
      },
    );
  }
}

class SearchWrapper extends StatefulWidget {
  final String tabFor;

  const SearchWrapper({super.key, required this.tabFor});

  @override
  OderWrapperState<SearchWrapper> createState() =>
  // ignore: no_logic_in_create_state
  _SearchWrapperState(tabFor);
}

class _SearchWrapperState extends OderWrapperState<SearchWrapper> {
  final String tabFor;

  _SearchWrapperState(this.tabFor);

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (context) {
        /* --------------------------------------------------------------------- Call Home Bloc */
        return HomeBloc(userRepository: sl());
      },
      /* ----------------------------------------------------------------------- Home bloc */
      child: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          /* ------------------------------------------------------------------- Listen to state error, popup error dialog */
          if (state is HomeError) {
            showErrorToast(state.error, context);
          }
          /* ------------------------------------------------------------------- Listen to network state error, popup error dialog */
          if (state is HomeNetworkError) {
            showErrorToast(state.error, context);
            // Navigator.pop(context);
          }
          /* ------------------------------------------------------------------- Listen to session state error, popup error dialog */
          if (state is HomeSessionError) {
            sessionExpiredLogOut(state.error);
          }
          /* ------------------------------------------------------------------- Listen to maintenance error, navigate to maintenance page */
          if (state is HomeMaintenanceError) {
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
          /* ------------------------------------------------------------------- Show content view for Searh view */
          return getPageView(<Widget>[
            SearchViewNew(changeView: changePage, tabFor: tabFor),
          ]);
        },
      ),
    );
  }
}
