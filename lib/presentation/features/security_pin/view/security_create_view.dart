import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app_setting/app_setting.dart';
import '../../../widgets/widgets.dart';
import '../security_pin.dart';

class SecurityCreateView extends StatefulWidget {
  final Function changeView;
  final int? voucherId;
  final String? title;

  const SecurityCreateView({
    super.key,
    required this.changeView,
    this.voucherId,
    this.title,
  });

  @override
  State<SecurityCreateView> createState() => _SecurityCreateViewState();
}

class _SecurityCreateViewState extends State<SecurityCreateView> {
  bool isProcessing = false;

  void setProcessingStatus(bool processing) {
    setState(() {
      isProcessing = processing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SecurityBloc, SecurityState>(
      listener: (context, securityState) {
        if (securityState is SecurityOtpSent) {
          setProcessingStatus(false);

          showSuccessToast(securityState.data['message'], context);
          Navigator.of(context).pushNamed(
            OderRoutes.securityOtp,
            arguments: SecurityOtpParameters(otpData: securityState.data),
          );
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: colorWhite,
            body: SingleChildScrollView(
              child: Container(
                color: colorBackground,
                height:
                    ScreenSize.height -
                    kToolbarHeight - // top AppBar height
                    MediaQuery.of(context).padding.top - // top padding
                    kBottomNavigationBarHeight -
                    30, // BottomNavigationBar height
                margin: EdgeInsets.symmetric(horizontal: marginHorizontal),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: ScreenSize.height * 0.18,
                      margin: EdgeInsets.symmetric(vertical: 50),
                      child: Image(
                        image: AssetImage(
                          'assets/icons/security/passcode.webp',
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                      child: Text(
                        'Generate a passcode for your end-to-end encrypted payment.',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: colorBlack,
                          fontFamily: fontFamilyMain,
                        ),
                        textScaler: TextScaler.linear(scaleFactor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        'This passcode helps us validate your transaction securely',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: colorTextGrey,
                          fontFamily: fontFamilyMain,
                        ),
                        textScaler: TextScaler.linear(scaleFactor),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        margin: EdgeInsets.symmetric(vertical: 20),
                        child: OderStyleButton(
                          title: 'Next',
                          textColor: isProcessing ? processingText : colorWhite,
                          backgroundColor:
                              isProcessing ? processing : colorBlackTab,
                          onPressed: () {
                            setProcessingStatus(true);

                            BlocProvider.of<SecurityBloc>(
                              context,
                            ).add(SecurityOtpSend());
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
