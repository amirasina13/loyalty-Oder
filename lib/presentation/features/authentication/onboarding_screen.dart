import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:oder_app/config/config.dart';

import '../wrapper.dart';
import 'authentication.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {},
          child: OnboardingWrapper(),
        ),
      ),
    );
  }
}

class OnboardingWrapper extends StatefulWidget {
  const OnboardingWrapper({super.key});

  @override
  OderWrapperState<OnboardingWrapper> createState() =>
      _OnboardingWrapperState();
}

class _OnboardingWrapperState extends OderWrapperState<OnboardingWrapper> {
  @override
  Widget build(BuildContext context) {
    return getPageView(<Widget>[OnBoard1View(changeView: changePage)]);
  }
}
