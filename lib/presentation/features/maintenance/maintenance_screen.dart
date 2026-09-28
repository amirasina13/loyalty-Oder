import 'package:flutter/material.dart';

import '../../../app_setting/app_setting.dart';
import '../../widgets/widgets.dart';

class MaintenanceParameters {
  final String message;

  const MaintenanceParameters({required this.message});
}

class MaintenanceScreen extends StatefulWidget {
  final MaintenanceParameters parameters;

  const MaintenanceScreen({super.key, required this.parameters});

  @override
  State<MaintenanceScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen> {
  // final dynamicLink = FirebaseDynamicLinks.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: marginHorizontal),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: ScreenSize.height * 0.18),
            Container(
              height: ScreenSize.height * 0.35,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  image: AssetImage('assets/image/maintenance.webp'),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 30),
              child: Text(
                widget.parameters.message,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: fontFamilyMain,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
