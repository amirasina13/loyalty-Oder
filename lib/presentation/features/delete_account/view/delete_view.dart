import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../app_setting/app_setting.dart';
import '../../../../domain/domain.dart';
import '../../../widgets/widgets.dart';
import '../../authentication/authentication.dart';
import '../../maintenance/maintenance_screen.dart';
import '../delete_acc.dart';

class DeleteMobileView extends StatefulWidget {
  final Function changeView;

  // ignore: use_key_in_widget_constructors
  const DeleteMobileView({Key? key, required this.changeView}) : super();

  @override
  State<DeleteMobileView> createState() => _DeleteMobileViewState();
}

class _DeleteMobileViewState extends State<DeleteMobileView> {
  // String selectedCode = '60';
  bool error = false;
  bool isProcessing = false;
  String errorfield = '', errorTextEmail = '';
  List<String> getCode = [];
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<OderInputFieldState> emailKey = GlobalKey();

  late FocusNode emailFocus;
  final MyConnectivity _connectivity = MyConnectivity.instance;

  void setProcessingStatus(bool processing) {
    setState(() {
      isProcessing = processing;
    });
  }

  @override
  void initState() {
    super.initState();

    emailFocus = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    emailFocus.dispose();

    _connectivity.disposeStream();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var sizeBetween = ScreenSize.height / 20;

    return Theme(
      data: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: errorfield == '' ? Colors.blueAccent : colorRed,
        ),
      ),
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          backgroundColor: colorBackground,
          body: BlocConsumer<DeleteAccBloc, DeleteAccState>(
            listener: (context, state) async {
              if (state is DeleteAccSent) {
                setProcessingStatus(false);

                try {
                  // Await secure storage wipe completely before proceeding
                  await Storage().secureStorage.deleteAll();
                } catch (e) {
                  if (!context.mounted) return;
                  // Handle or log secure storage wipe exceptions safely
                  showErrorToast(
                    'Failed to clear secure storage during account deletion',
                    context,
                  );
                }

                if (!context.mounted) return;

                // Notify central AuthenticationBloc to reset in-memory state & storage
                BlocProvider.of<AuthenticationBloc>(
                  context,
                ).add(AuthenticationLoggedOut());

                showSuccessToast(state.message, context);
                Navigator.of(context).pushNamedAndRemoveUntil(
                  OderRoutes.login,
                  (Route<dynamic> route) => false,
                );
              }
              // on failure show a error dialog
              if (state is DeleteAccError) {
                setProcessingStatus(false);
                // ignore: unnecessary_null_comparison
                state.error != null ? error = true : error = false;
                setProcessingStatus(false);

                // ErrorIconDialog.showErrorDialog(context, state.error);
                showErrorToast(state.error, context);
                Navigator.pop(context);
              }
              if (state is DeleteAccMaintenanceError) {
                setProcessingStatus(false);

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
              if (state is DeleteAccProcessing) {
                // return LoadingWidget();
              }
              return SingleChildScrollView(
                reverse: true, // this is new
                physics: BouncingScrollPhysics(),
                child: Container(
                  // height: height * 0.8,
                  color: colorWhite,
                  // padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
                  margin: EdgeInsets.fromLTRB(
                    marginHorizontal,
                    0,
                    marginHorizontal,
                    25,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 50),
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                        height: ScreenSize.height / 7,
                        child: Text(
                          'Delete My Account',
                          style: TextStyle(
                            fontFamily: fontFamilyMain,
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      SizedBox(height: sizeBetween / 3),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: Text(
                          'Email',
                          style: TextStyle(
                            fontFamily: fontFamilyMain,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        // padding: EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          color: colorBackground,
                          boxShadow: [
                            BoxShadow(
                              color:
                                  error
                                      ? colorRed
                                      : errorfield == 'error' ||
                                          errorfield == 'errorEmail'
                                      ? colorRed
                                      : colorGreyBox,
                              // blurRadius: 15.0,
                              offset: Offset(
                                0.0,
                                error
                                    ? 3
                                    : errorfield == 'error' ||
                                        errorfield == 'errorEmail'
                                    ? 3
                                    : 0,
                              ),
                            ),
                          ],
                          border: Border.all(color: colorGreyBox),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: OderInputField(
                          key: emailKey,
                          controller: emailController,
                          // hint: 'Example: 123456789',
                          validator: Validator.valueExists,
                          keyboard: TextInputType.emailAddress,
                          border: InputBorder.none,
                          focusNode: emailFocus,
                          onValueChanged: (value) {
                            if (value != '') {
                              setState(() {
                                errorfield = '';
                                error = false;
                                emailKey.currentState?.validate();
                              });
                            }
                          },
                        ),
                      ),
                      errorfield == 'error' || errorfield == 'errorEmail'
                          ? Container(
                            margin: EdgeInsets.only(top: 5),
                            child: Text(
                              errorTextEmail,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                color:
                                    error
                                        ? colorRed
                                        : errorfield == 'error' ||
                                            errorfield == 'errorEmail'
                                        ? colorRed
                                        : colorGreyBox,
                              ),
                            ),
                          )
                          : SizedBox(),
                      Container(
                        width: ScreenSize.width,
                        margin: EdgeInsets.symmetric(vertical: 30),
                        decoration: BoxDecoration(
                          color: colorLightGray,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 8.0,
                              offset: Offset(0.0, 5.0),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RichText(
                              text: TextSpan(
                                // Note: Styles for TextSpans must be explicitly defined.
                                // Child text spans will inherit styles from parent
                                style: const TextStyle(
                                  fontSize: 12.0,
                                  color: colorRed,
                                  fontFamily: fontFamilyMain,
                                ),
                                children: const [
                                  TextSpan(
                                    text:
                                        'OH NO! YOU ARE ABOUT TO DELETE THIS ACCOUNT',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        '\n\n1. This email will be disabled for new registration within a year. \n2. All unspent $appName vouchers will be forfeited.', //credits / points and vouchers
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  // TextSpan(
                                  //   text: '\n\n Are you sure to ',
                                  // ),
                                  // TextSpan(
                                  //   text: 'PROCEED? ',
                                  //   style: TextStyle(fontWeight: FontWeight.bold),
                                  // ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: ScreenSize.width * 0.2,
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  // Note: Styles for TextSpans must be explicitly defined.
                                  // Child text spans will inherit styles from parent
                                  style: const TextStyle(
                                    fontSize: 12.0,
                                    color: colorRed,
                                    fontFamily: fontFamilyMain,
                                  ),
                                  children: const [
                                    TextSpan(text: '\n\n Are you sure to '),
                                    TextSpan(
                                      text: 'PROCEED? ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: sizeBetween * 2),
                    ],
                  ),
                ),
              );
            },
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                // color: colorLightGray,
                margin: EdgeInsets.symmetric(horizontal: marginHorizontal),
                child: Container(
                  alignment: Alignment.bottomCenter,
                  child: OderStyleButton(
                    height: ScreenSize.height / 14,
                    title: 'Submit',
                    backgroundColor: isProcessing ? processing : colorBlackTab,
                    textColor: isProcessing ? processingText : colorWhite,
                    onPressed: isProcessing ? () {} : _validateAndSend,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    // color: colorBabyBlue,
                    alignment: Alignment.center,
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 15,
                        color: colorBlack,
                        fontWeight: FontWeight.w400,
                        decoration: TextDecoration.underline,
                      ),
                      textScaler: TextScaler.linear(scaleFactor),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _validateAndSend() {
    fToast = FToast();
    fToast.init(context);

    if (emailKey.currentState?.validate() != null) {
      setProcessingStatus(false);
      errorfield = 'errorEmail';
      emailFocus.requestFocus();
      errorTextEmail = 'The email address is required!';
      // showErrorToast('Please enter valid email address!', context);
    } else {
      errorfield = '';
      // setProcessingStatus(true);

      showDialog(
        context: context,
        useSafeArea: false,
        builder: (context) {
          // timerDialog = Timer(Duration(seconds: 3), navigation);
          // // and later, before the timer goes off...
          // timerDialog;

          return AlertDialog(
            contentPadding: EdgeInsets.all(20.0),
            insetPadding: EdgeInsets.zero,
            backgroundColor: colorBackground,
            content: Container(
              color: colorBackground,
              alignment: Alignment.center,
              // height: height * 0.5,
              // padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              child: Column(
                // mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // Expanded(
                  //   flex: 2,
                  //   child:
                  Container(
                    height: ScreenSize.width * 0.2,
                    width: ScreenSize.width * 0.2,
                    color: colorTransparent,
                    child: Image(image: AssetImage('assets/icons/bin.webp')),
                  ),
                  Container(
                    // color: colorLightBlue,
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      'Are you sure you want to permanently delete your account',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: colorTextGrey,
                      ),
                      textAlign: TextAlign.center,
                      textScaler: TextScaler.linear(scaleFactor),
                    ),
                  ),
                  Container(
                    // color: colorLightBlue,
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      '${emailController.text} ?',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: colorBlack,
                      ),
                      textAlign: TextAlign.center,
                      textScaler: TextScaler.linear(scaleFactor),
                    ),
                  ),
                  SizedBox(height: ScreenSize.height * 0.03),
                  Container(
                    // color: colorLightBlue,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'This action cannot be undone.',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: colorTextGrey,
                      ),
                      textAlign: TextAlign.center,
                      textScaler: TextScaler.linear(scaleFactor),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          alignment: Alignment.bottomCenter,
                          child: OderStyleButton(
                            backgroundColor: colorRed,
                            height: ScreenSize.height / 16,
                            width: ScreenSize.width,
                            title: 'Delete',
                            onPressed: _confirmDeleteAccount,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 10, bottom: 5),
                            padding: EdgeInsets.symmetric(vertical: 10),
                            // color: colorBabyBlue,
                            alignment: Alignment.center,
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 15,
                                color: colorBlack,
                                fontWeight: FontWeight.w400,
                                decoration: TextDecoration.underline,
                              ),
                              textScaler: TextScaler.linear(scaleFactor),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  void _confirmDeleteAccount() {
    setProcessingStatus(true);

    BlocProvider.of<DeleteAccBloc>(
      context,
    ).add(DeleteAccSend(email: emailController.text));
  }
}
