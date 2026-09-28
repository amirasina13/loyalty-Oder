import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app_setting/app_setting.dart';
import '../../../locator.dart';
import '../../widgets/widgets.dart';
import '../profile/profile.dart';
import '../wrapper.dart';
import 'setup.dart';

class EValidParameters {
  final Map loginData;

  const EValidParameters({required this.loginData});
}

class EValidScreen extends StatefulWidget {
  final EValidParameters parameters;

  const EValidScreen({super.key, required this.parameters});

  @override
  State<EValidScreen> createState() => _EValidScreenState();
}

class _EValidScreenState extends State<EValidScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: colorBackground,
        systemNavigationBarColor: colorWhite,
      ),
      child: BlocBuilder<ProfileBloc, ProfileState>(
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
            child: Scaffold(
              backgroundColor: colorWhite,
              body: EValidWrapper(loginData: widget.parameters.loginData),
            ),
          );
        },
      ),
    );
  }
}

class EValidWrapper extends StatefulWidget {
  final Map loginData;

  const EValidWrapper({super.key, required this.loginData});

  @override
  OderWrapperState<EValidWrapper> createState() =>
  // ignore: no_logic_in_create_state
  _EValidWrapperState(loginData);
}

class _EValidWrapperState extends OderWrapperState<EValidWrapper> {
  final Map loginData;

  _EValidWrapperState(this.loginData);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SetupBloc>(
          create: (context) => SetupBloc(userRepository: sl()),
        ),
        // BlocProvider<ProfileBloc>(
        //   create: (context) =>
        //       ProfileBloc(userRepository: sl())..add(ProfileLoad()),
        // ),
      ],
      child: getPageView(<Widget>[
        EvalidView(changeView: changePage, loginData: loginData),
      ]),
    );
  }
}
