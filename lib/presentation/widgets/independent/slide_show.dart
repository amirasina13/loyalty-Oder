import 'package:flutter/material.dart';

import '../../../app_setting/app_setting.dart';
import '../../features/authentication/authentication.dart';
import '../widgets.dart';

class SlideInformationWidget extends StatefulWidget {
  final List<SlideInfo> slides;
  final Duration slideDuration;
  final TextStyle? titleStyle;
  final TextStyle? descriptionStyle;
  final Color? backgroundColor;
  final Color? indicatorColor;
  final Color? activeIndicatorColor;

  const SlideInformationWidget({
    super.key,
    required this.slides,
    this.slideDuration = const Duration(seconds: 5),
    this.titleStyle,
    this.descriptionStyle,
    this.backgroundColor,
    this.indicatorColor,
    this.activeIndicatorColor,
  });

  @override
  State<SlideInformationWidget> createState() => _SlideInformationWidgetState();
}

class _SlideInformationWidgetState extends State<SlideInformationWidget> {
  int _currentPage = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    // _startSlideShow();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // void _startSlideShow() {
  //   Future.delayed(widget.slideDuration, () {
  //     if (mounted) {
  //       setState(() {
  //         _currentPage = (_currentPage + 1) % widget.slides.length;
  //         _pageController.animateToPage(
  //           _currentPage,
  //           duration: Duration(milliseconds: 500),
  //           curve: Curves.ease,
  //         );
  //       });
  //       _startSlideShow();
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.slides.length,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
              if (page == widget.slides.length - 1) {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder:
                        (context, animation, secondaryAnimation) =>
                            LoadingOnboard(),
                  ),
                );
              }
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: marginHorizontal,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.slides[index].image != null)
                      SizedBox(child: widget.slides[index].image),
                    SizedBox(height: ScreenSize.height * 0.05),
                    Text(
                      widget.slides[index].title,
                      style:
                          widget.titleStyle ??
                          TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            fontFamily: fontFamilyMain,
                            color: colorBlackText,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        widget.slides[index].description,
                        style:
                            widget.descriptionStyle ??
                            TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              fontFamily: fontFamilyMain,
                              color: colorBlackText,
                            ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.slides.length - 1,
            (index) => Container(
              width: ScreenSize.width * 0.05,
              height: 10.0,
              margin: EdgeInsets.symmetric(vertical: 10.0),
              decoration: BoxDecoration(
                shape:
                    _currentPage == index
                        ? BoxShape.rectangle
                        : BoxShape.circle,
                color:
                    _currentPage == index ? colorYellowIndicator : colorWhite,
                border: Border.all(color: colorYellowIndicator),
                borderRadius:
                    _currentPage == index ? BorderRadius.circular(10) : null,
              ),
            ),
            // Container(
            //   width: 8.0,
            //   height: 8.0,
            //   margin: EdgeInsets.fromLTRB(0, 30, 10, 0),
            //   decoration: BoxDecoration(
            //     shape: BoxShape.circle,
            //     color:
            //         _currentPage == index
            //             ? widget.activeIndicatorColor ?? colorGoldButton
            //             : widget.indicatorColor ?? Colors.grey,
            //   ),
            // ),
          ),
        ),
      ],
    );
  }
}

class SlideInfo {
  final String title;
  final String description;
  final Image? image;

  SlideInfo({required this.title, required this.description, this.image});
}
