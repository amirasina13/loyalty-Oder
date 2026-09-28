import 'package:flutter/material.dart';

import '../../../../app_setting/app_setting.dart';
import '../../../../util/utils.dart';
import '../../../widgets/widgets.dart';
import '../authentication.dart';

class OnBoard1View extends StatefulWidget {
  final Function changeView;

  const OnBoard1View({super.key, required this.changeView});

  @override
  State<OnBoard1View> createState() => _OnBoard1ViewState();
}

class _OnBoard1ViewState extends State<OnBoard1View> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: ScreenSize.height,
        width: ScreenSize.width,
        padding: EdgeInsets.fromLTRB(
          marginHorizontal,
          ScreenSize.height * 0.07,
          marginHorizontal,
          0,
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/image/onboard1.webp'),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          children: [
            Image(
              image: AssetImage(mainLogo),
              height: ScreenSize.height * 0.13,
            ),
            SizedBox(height: ScreenSize.height * 0.08),
            Image(
              image: AssetImage('assets/image/img_board1.webp'),
              height: ScreenSize.height * 0.35,
            ),
            SizedBox(height: ScreenSize.height * 0.04),
            Text(
              'Earn, Save, Repeat!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                fontFamily: fontFamilyMain,
                color: colorBlackText,
              ),
            ),
            SizedBox(height: ScreenSize.height * 0.04),
            OderStyleButton(
              title: 'GET STARTED!',
              textColor: colorMulberry,
              backgroundColor: colorGoldButton,
              borderRadius: 30,
              height: ScreenSize.height * 0.055,
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  NoAnimationPageRoute(builder: (context) => OnBoard2View()),
                  ModalRoute.withName('/'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
