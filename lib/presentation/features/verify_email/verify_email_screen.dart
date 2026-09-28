import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app_setting/app_setting.dart';
import '../../../data/data.dart';
import '../../widgets/widgets.dart';
import '../profile/profile.dart';
import '../wrapper.dart';
import 'verify_email.dart';

class VerifyEmailParameters {
  final String email;

  const VerifyEmailParameters({required this.email});
}

class VerifyEmailScreen extends StatefulWidget {
  final VerifyEmailParameters parameters;

  const VerifyEmailScreen({super.key, required this.parameters});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
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
          child: Scaffold(
            backgroundColor: colorWhite,
            body: BlocProvider<VerifyEmailBloc>(
              create: (context) {
                return VerifyEmailBloc(
                  userRepository: RepositoryProvider.of<UserRepository>(
                    context,
                  ),
                );
              },
              child: VerifyEmailWrapper(email: widget.parameters.email),
            ),
            bottomNavigationBar: OderBottomMenu(3, false, true),
          ),
        );
      },
    );
  }
}

class VerifyEmailWrapper extends StatefulWidget {
  final String email;
  const VerifyEmailWrapper({super.key, required this.email});

  @override
  OderWrapperState<VerifyEmailWrapper> createState() =>
  // ignore: no_logic_in_create_state
  _VerifyEmailWrapperState(email);
}

class _VerifyEmailWrapperState extends OderWrapperState<VerifyEmailWrapper> {
  String email;
  _VerifyEmailWrapperState(this.email);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VerifyEmailBloc, VerifyEmailState>(
      builder: (context, state) {
        return getPageView(<Widget>[
          EmailVerifyView(changeView: changePage, email: email),
        ]);
      },
    );
  }
}
