import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app_setting/app_setting.dart';
import '../../../locator.dart';
import '../../widgets/widgets.dart';
import '../country/country.dart';
import '../profile/profile.dart';
import '../wrapper.dart';
import 'setup.dart';

class VProfileParameters {
  final Map profile;

  const VProfileParameters({required this.profile});
}

class VProfileScreen extends StatefulWidget {
  final VProfileParameters parameters;

  const VProfileScreen({super.key, required this.parameters});

  @override
  State<VProfileScreen> createState() => _VProfileScreenState();
}

class _VProfileScreenState extends State<VProfileScreen> {
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
              body: VProfileWrapper(profile: widget.parameters.profile),
            ),
          ),
        );
      },
    );
  }
}

class VProfileWrapper extends StatefulWidget {
  final Map profile;

  const VProfileWrapper({super.key, required this.profile});

  @override
  OderWrapperState<VProfileWrapper> createState() =>
  // ignore: no_logic_in_create_state
  _VProfileWrapperState(profile);
}

class _VProfileWrapperState extends OderWrapperState<VProfileWrapper> {
  final Map profile;
  _VProfileWrapperState(this.profile);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProfileBloc>(
          create:
              (context) =>
                  ProfileBloc(userRepository: sl())..add(ProfileLoad()),
        ),
        BlocProvider<CountryBloc>(
          create: (context) => CountryBloc()..add(CountryLoad()),
        ),
      ],
      child: getPageView(<Widget>[
        VProfileView(changeView: changePage, profile: profile),
      ]),
    );
  }
}
