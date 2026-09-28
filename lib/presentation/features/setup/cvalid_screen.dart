import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app_setting/app_setting.dart';
import '../../../locator.dart';
import '../../widgets/widgets.dart';
import '../profile/profile.dart';
import '../wrapper.dart';
import 'setup.dart';

class CValidParameters {
  final Map profile;

  const CValidParameters({required this.profile});
}

class CValidScreen extends StatefulWidget {
  final CValidParameters parameters;

  const CValidScreen({super.key, required this.parameters});

  @override
  State<CValidScreen> createState() => _RegisterCValidScreenState();
}

class _RegisterCValidScreenState extends State<CValidScreen> {
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

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            systemNavigationBarColor: colorWhite,
            statusBarColor: colorWhite,
          ),
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Scaffold(
              backgroundColor: colorWhite,
              body: CValidWrapper(profile: widget.parameters.profile),
            ),
          ),
        );
      },
    );
  }
}

class CValidWrapper extends StatefulWidget {
  final Map profile;

  const CValidWrapper({super.key, required this.profile});

  @override
  OderWrapperState<CValidWrapper> createState() =>
  // ignore: no_logic_in_create_state
  _CValidWrapperState(profile);
}

class _CValidWrapperState extends OderWrapperState<CValidWrapper> {
  final Map profile;
  _CValidWrapperState(this.profile);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SetupBloc>(
          create: (context) => SetupBloc(userRepository: sl()),
        ),
      ],
      child: getPageView(<Widget>[
        CValidView(changeView: changePage, profile: profile),
      ]),
    );
  }
}
