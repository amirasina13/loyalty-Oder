import 'package:flutter/material.dart';

class NoAnimationPageRoute extends MaterialPageRoute {
  // ignore: use_super_parameters
  NoAnimationPageRoute({builder, settings})
    : super(builder: builder, settings: settings);

  @override
  Duration get transitionDuration => const Duration(milliseconds: 0);

  @override
  Duration get reverseTransitionDuration => const Duration(milliseconds: 0);
}
