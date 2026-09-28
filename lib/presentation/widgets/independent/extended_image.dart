import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

import '../../../app_setting/app_setting.dart';
import '../widgets.dart';

class SimplePicsWiper extends StatefulWidget {
  const SimplePicsWiper({super.key, required this.url, required this.images});
  final String url;
  final List<String> images;

  @override
  State<SimplePicsWiper> createState() => _SimplePicsWiperState();
}

class _SimplePicsWiperState extends State<SimplePicsWiper> {
  GlobalKey<ExtendedImageSlidePageState> slidePagekey =
      GlobalKey<ExtendedImageSlidePageState>();

  final List<int> _cachedIndexes = <int>[];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final int index = widget.images.indexOf(widget.url);
    _preloadImage(index - 1);
    _preloadImage(index + 1);
  }

  void _preloadImage(int index) {
    if (_cachedIndexes.contains(index)) {
      return;
    }
    if (0 <= index && index < widget.images.length) {
      final String url = widget.images[index];
      if (url.startsWith('https:')) {
        precacheImage(ExtendedNetworkImageProvider(url, cache: true), context);
      }

      _cachedIndexes.add(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: colorBackground,
      // child: ExtendedImageSlidePage(
      //   key: slidePagekey,
      //   slideAxis: SlideAxis.both,
      //   slideType: SlideType.wholePage,
      //   // child: GestureDetector(
      child: Stack(
        children: [
          ExtendedImageGesturePageView.builder(
            controller: ExtendedPageController(
              initialPage: widget.images.indexOf(widget.url),
              pageSpacing: 50,
              shouldIgnorePointerWhenScrolling: false,
            ),
            itemCount: widget.images.length,
            onPageChanged: (int page) {
              _preloadImage(page - 1);
              _preloadImage(page + 1);
            },
            itemBuilder: (BuildContext context, int index) {
              final String url = widget.images[index];

              return url == 'This is an video'
                  ? ExtendedImageSlidePageHandler(
                    child: Material(
                      child: Container(
                        alignment: Alignment.center,
                        color: colorBackground,
                        child: const Text('This is an video'),
                      ),
                    ),

                    ///make hero better when slide out
                    heroBuilderForSlidingPage: (Widget result) {
                      return GestureDetector(
                        child: Hero(
                          tag: url,
                          child: result,
                          flightShuttleBuilder: (
                            BuildContext flightContext,
                            Animation<double> animation,
                            HeroFlightDirection flightDirection,
                            BuildContext fromHeroContext,
                            BuildContext toHeroContext,
                          ) {
                            final Hero hero =
                                (flightDirection == HeroFlightDirection.pop
                                        ? fromHeroContext.widget
                                        : toHeroContext.widget)
                                    as Hero;

                            return hero.child;
                          },
                        ),
                      );
                    },
                  )
                  : HeroWidget(
                    tag: url,
                    slideType: SlideType.wholePage,
                    slidePagekey: slidePagekey,
                    child: ExtendedImage.network(
                      url,
                      // enableSlideOutPage: true,
                      // retries: 1,
                      fit: BoxFit.contain,
                      mode: ExtendedImageMode.gesture,
                      initGestureConfigHandler: (ExtendedImageState state) {
                        return GestureConfig(
                          animationMinScale: 0.7,
                          maxScale: 3.0,
                          animationMaxScale: 3.5,
                          speed: 1.0,
                          inPageView: true,
                          initialAlignment: InitialAlignment.center,
                          // //you must set inPageView true if you want to use ExtendedImageGesturePageView
                          // inPageView: true,
                          // initialScale: 1.0,
                          // maxScale: 5.0,
                          // animationMaxScale: 6.0,
                          // initialAlignment: InitialAlignment.center,
                        );
                      },
                    ),
                  );
            },
          ),
          Positioned(
            top: ScreenSize.height * 0.05,
            right: 20,
            // bottom: -46,
            child: InkWell(
              child: Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorLightGray,
                ),
                child: Icon(Icons.close_rounded, color: colorBlack, size: 25),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
      // onTap: () {
      //   slidePagekey.currentState!.popPage();
      //   Navigator.pop(context);
      // },
      // ),
      //   ),
    );
  }
}
