import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../app_setting/app_setting.dart';
import '../../../../domain/domain.dart';
import '../../../widgets/widgets.dart';
import '../../maintenance/maintenance_screen.dart';
import '../../profile/profile.dart';
import '../verify_email.dart';

class EmailVerifyView extends StatefulWidget {
  final Function changeView;
  final String email;

  const EmailVerifyView({
    super.key,
    required this.changeView,
    required this.email,
  });

  @override
  State<EmailVerifyView> createState() => _EmailVerifyViewState();
}

class _EmailVerifyViewState extends State<EmailVerifyView> {
  String errorfield = '';
  bool isProcessing = false;
  late FocusNode validateFocus;
  final TextEditingController verifyEmailController = TextEditingController();
  final GlobalKey<OderInputFieldState> verifyEmailKey = GlobalKey();

  void setProcessingStatus(bool processing) {
    setState(() {
      isProcessing = processing;
    });
  }

  @override
  void initState() {
    super.initState();

    validateFocus = FocusNode();
    verifyEmailController.text = widget.email;
  }

  @override
  void dispose() {
    verifyEmailController.dispose();

    // Clean up the focus node when the Form is disposed.
    validateFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var sizeBetween = ScreenSize.height / 20;

    return Theme(
      data: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: errorfield == '' ? colorDarkGray : colorRed,
        ),
      ),
      child: Scaffold(
        backgroundColor: colorBackground,
        appBar: AppBar(
          iconTheme: IconThemeData(color: colorBlack),
          elevation: 0,
          backgroundColor: colorBackground,
          title: Text(
            'Verify Email',
            style: TextStyle(
              color: colorBlack,
              fontWeight: FontWeight.w400,
              fontSize: 15,
              fontFamily: fontFamilyMain,
            ),
            textScaler: TextScaler.linear(scaleFactor),
          ),
          centerTitle: true,
        ),
        body: BlocConsumer<VerifyEmailBloc, VerifyEmailState>(
          listener: (context, state) {
            if (state is VerifyEmailSent) {
              setProcessingStatus(false);
              Navigator.of(context).pushNamed(OderRoutes.verifyEmailOtp);
              EmailDialog.showEmailDialog(context, state.data['message']);
              //
            }
            // on failure show a snackbar
            if (state is VerifyEmailError) {
              setProcessingStatus(false);
              showErrorToast(state.error, context);
            }

            if (state is VerifyNetworkError) {
              setProcessingStatus(false);
              showErrorToast(state.error, context);
            }

            if (state is VerifyEmailMaintenanceError) {
              Navigator.pushAndRemoveUntil<void>(
                context,
                MaterialPageRoute<void>(
                  builder:
                      (BuildContext context) => MaintenanceScreen(
                        parameters: MaintenanceParameters(
                          message: state.message,
                        ),
                      ),
                ),
                ModalRoute.withName('/'),
              );
            }
          },
          builder: (context, state) {
            // show loading screen while processing
            if (state is VerifyEmailProcessing) {}
            return SingleChildScrollView(
              reverse: true, // this is new
              physics: BouncingScrollPhysics(),
              child: Container(
                color: colorBackground,
                margin: EdgeInsets.symmetric(horizontal: marginHorizontal),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 20),
                      padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
                      height: ScreenSize.height / 7,
                      decoration: BoxDecoration(
                        color: colorBackground,
                        image: DecorationImage(
                          fit: BoxFit.contain,
                          image: AssetImage(mainLogo),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 50, bottom: 10),
                      child: BlocBuilder<ProfileBloc, ProfileState>(
                        builder: (context, state) {
                          return /* -------------------------------------------- Email input field */ OderRoundField(
                            focusBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color:
                                    errorfield == 'error'
                                        ? colorRed
                                        : colorDarkGray,
                              ),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            prefixIcon: Container(
                              width: ScreenSize.width * 0.15,
                              color: colorTransparent,
                              child: IntrinsicHeight(
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(15, 0, 10, 0),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(right: 7),
                                        child: Image(
                                          color: colorBlackDesc,
                                          width: ScreenSize.width * 0.05,
                                          height: ScreenSize.width * 0.05,
                                          image: AssetImage(
                                            'assets/icons/profile/email_icon.webp',
                                          ),
                                        ),
                                      ),
                                      const VerticalDivider(
                                        width: 2,
                                        thickness: 1,
                                        indent: 10,
                                        endIndent: 10,
                                        color: colorUsedGray,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            key: verifyEmailKey,
                            controller: verifyEmailController,
                            label: 'Email',
                            labelStyle: TextStyle(
                              color:
                                  errorfield == 'error'
                                      ? colorRed
                                      : colorDarkGray,
                              fontSize: 13,
                            ),
                            validator: Validator.valueExists,
                            keyboard: TextInputType.text,
                            border: InputBorder.none,
                            focusNode: validateFocus,
                          );
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 30.0),
                      child: Text(
                        'Please confirm that you want to use this as your account email address.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: fontFamilyMain,
                          fontSize: 11,
                          // fontWeight: FontWeight.w600,
                          color: colorBlack,
                        ),
                        textScaler: TextScaler.linear(scaleFactor),
                      ),
                    ),
                    SizedBox(height: sizeBetween * 2),
                  ],
                ),
              ),
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Container(
          margin: EdgeInsets.symmetric(horizontal: marginHorizontal),
          alignment: Alignment.bottomCenter,
          // margin: EdgeInsets.only(bottom: 20),
          child: OderStyleButton(
            title: 'Send Verification Email',
            height: ScreenSize.height / 14,
            backgroundColor: isProcessing ? colorLightGray : mainColor,
            textColor: isProcessing ? colorDarkGray : colorWhite,
            onPressed: isProcessing ? () {} : _validateAndSend,
          ),
        ),
      ),
    );
  }

  void _validateAndSend() {
    if (!mounted) return;
    setState(() {
      fToast = FToast();
      fToast.init(context);
    });

    if (verifyEmailKey.currentState?.validate() != null) {
      setProcessingStatus(false);
      errorfield = 'error';
      validateFocus.requestFocus();
      showErrorToast('Email is empty or incorrect format.', context);
    } else {
      errorfield = '';
      setProcessingStatus(true);
      BlocProvider.of<VerifyEmailBloc>(
        context,
      ).add(VerifyEmailSend(email: verifyEmailController.text));
    }
  }
}
