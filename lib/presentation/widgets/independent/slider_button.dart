import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../app_setting/app_setting.dart';
import '../widgets.dart';

class SlideButton extends StatefulWidget {
  ///Use it to define a height and width of widget.
  final double? height;
  final double? width;
  // final double? buttonSize;

  /// Use this parameter in case if your slider button is wide and not squared.
  // final double? buttonWidth;

  ///Sets the radius of corners of a button.
  final double radius;

  ///To make button more customizable add your child widget
  // final Widget? child;

  ///Change it to gave a text on a widget of your choice.
  final Widget? textButton;

  ///Change it to gave a text slide on a widget of your choice.
  final Widget? textSlide;

  ///Use it to define a color of widget.
  final Color backgroundColor;
  final Color slideColor;
  // final Color highlightedColor;
  // final Color buttonColor;

  ///Gives a alignment to a slider icon.
  // final Alignment? alignLabel;
  // final BoxShadow? boxShadow;
  final Widget? icon;
  // final Future<bool?> Function() action;

  ///Make it false if you want to deactivate the shimmer effect.
  final bool shimmer;

  // ///The offset threshold the item has to be dragged in order to be considered
  // ///dismissed e.g. if it is 0.4, then the item has to be dragged
  // /// at least 40% towards one direction to be considered dismissed
  // final double dismissThresholds;

  // final bool disable;

  final bool disable;
  final SliderButtonController? controller;
  final Function() onSlided;

  const SlideButton({
    super.key,
    this.height,
    this.width,
    // this.buttonSize,
    // this.buttonWidth,
    this.radius = 10,
    // this.child,
    this.textButton,
    this.textSlide,
    this.backgroundColor = mainColor,
    this.slideColor = colorWhite,
    // this.highlightedColor = colorGrey,
    // this.buttonColor = secondaryColor,
    // this.alignLabel,
    // this.boxShadow,
    this.icon,
    // required this.action,
    this.shimmer = false,
    // this.dismissThresholds = 0.75,
    this.disable = false,
    // this.enabled = true,
    this.controller,
    required this.onSlided,
  });

  @override
  State<SlideButton> createState() => _SlideButtonState();
}

class _SlideButtonState extends State<SlideButton>
    with SingleTickerProviderStateMixin {
  double _sliderRelativePosition = 0.0; // values 0 -> 1
  double _startedDraggingAtX = 0.0;
  late final AnimationController _animationController;
  late final Animation _sliderAnimation;
  late bool flag;

  @override
  void initState() {
    super.initState();
    flag = false;

    if (widget.controller != null) {
      widget.controller!.addListener(reset);
    }
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _sliderAnimation = CurveTween(
      curve: Curves.easeInQuad,
    ).animate(_animationController);

    _animationController.addListener(() {
      setState(() {
        _sliderRelativePosition = _sliderAnimation.value;
      });
    });
  }

  void reset() {
    _animationController.reverse(from: _sliderRelativePosition);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.radius),
        // border: _border,
      ),
      child: LayoutBuilder(
        builder: (_, BoxConstraints constraints) {
          final sliderRadius = widget.height ?? (ScreenSize.height / 20) / 2;
          final sliderMaxX = constraints.maxWidth - 2 * sliderRadius;
          final sliderPosX = sliderMaxX * _sliderRelativePosition;
          final backgroundSplitX = sliderPosX + sliderRadius;

          return Stack(
            children: [
              Row(
                children: [
                  Container(
                    height: ScreenSize.height / 14,
                    width: backgroundSplitX,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(widget.radius),
                      // border: Border.all(
                      //   color: colorBlack,
                      // ),
                      color:
                          widget.disable || flag == true
                              ? colorSoftGrey
                              : widget.slideColor,
                    ),
                    child:
                        widget.textSlide == null
                            ? SizedBox()
                            : SizedBox(
                              height: ScreenSize.height / 14,
                              child: Center(
                                child:
                                    flag == true
                                        ? Text(
                                          'Unlocked',
                                          style: TextStyle(
                                            fontFamily: fontFamilyMain,
                                            letterSpacing: 2,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                            color: colorBlack,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )
                                        : widget.textSlide,
                              ),
                            ),
                  ),
                  Container(
                    height: ScreenSize.height / 14,
                    width: constraints.maxWidth - backgroundSplitX,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(widget.radius),
                      color:
                          widget.disable || flag == true
                              ? colorDarkGray
                              : widget.backgroundColor,
                    ),
                    child:
                        widget.shimmer && !widget.disable
                            ? Shimmer.fromColors(
                              baseColor:
                                  widget.disable
                                      ? colorTextYellow
                                      : Colors.black,
                              highlightColor: colorBackground,
                              child:
                                  widget.textButton == null
                                      ? SizedBox()
                                      : SizedBox(
                                        height: ScreenSize.height / 14,
                                        child: Center(child: widget.textButton),
                                      ),
                            )
                            : widget.textButton == null
                            ? SizedBox()
                            : widget.disable
                            ? SizedBox(
                              height: ScreenSize.height / 14,
                              child: Center(
                                child: Text(
                                  'Redeem Now',
                                  style: TextStyle(
                                    fontFamily: fontFamilyMain,
                                    letterSpacing: 2,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: processingText,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            )
                            : SizedBox(
                              height: ScreenSize.height / 14,
                              child: Center(child: widget.textButton),
                            ),
                  ),
                ],
              ),
              // widget.text == null
              //           ? SizedBox()
              //           : SizedBox(
              //               height: height / 14,
              //               child: Center(
              //                 child: Text(
              //                   widget.text!,
              //                   // style: Theme.of(context).textTheme.titleLarge,
              //                   overflow: TextOverflow.ellipsis,
              //                 ),
              //               ),
              //             ),
              Positioned(
                left: sliderPosX,
                child: GestureDetector(
                  onHorizontalDragStart: (start) {
                    if (widget.disable || flag == true) {
                      return;
                    }
                    _startedDraggingAtX = sliderPosX;
                    _animationController.stop();
                  },
                  onHorizontalDragUpdate: (update) {
                    if (widget.disable || flag == true) {
                      return;
                    }
                    final newSliderPositionX =
                        _startedDraggingAtX + update.localPosition.dx;
                    final newSliderRelativePosition =
                        newSliderPositionX / sliderMaxX;
                    setState(() {
                      _sliderRelativePosition = max(
                        0,
                        min(1, newSliderRelativePosition),
                      );
                    });
                  },
                  onHorizontalDragEnd: (end) async {
                    if (widget.disable || flag == true) {
                      return;
                    }
                    if (_sliderRelativePosition == 1.0) {
                      flag = await widget.onSlided();
                      widget.onSlided();
                    } else {
                      reset();
                    }
                  },
                  child: Container(
                    height: ScreenSize.height / 14,
                    width: ScreenSize.height / 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(widget.radius),
                      // border: Border(
                      //   bottom: BorderSide(color: colorBlack),
                      //   top: BorderSide(color: colorBlack),
                      // ),
                      // border: Border.all(
                      //   color: colorBlack,
                      // ),
                      color:
                          widget.disable
                              ? colorSoftGrey
                              : flag == true
                              ? colorDarkGray
                              : widget.slideColor,
                      // border: Border.all(color: Theme.of(context).shadowColor),
                    ),
                    child: widget.icon,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/* ----------------------------------------------------------------------------- */
class SliderButtonController extends ChangeNotifier {
  void reset() {
    notifyListeners();
  }
}
