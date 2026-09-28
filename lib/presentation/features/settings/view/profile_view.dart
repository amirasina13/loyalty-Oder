import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../../../../app_setting/app_setting.dart';
import '../../../../domain/domain.dart';
import '../../../widgets/widgets.dart';
import '../../maintenance/maintenance_screen.dart';
import '../../photo/photo.dart';
import '../../profile/profile.dart';

class ProfileView extends StatefulWidget {
  final Function? changeView;

  const ProfileView({super.key, this.changeView});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  // with AutomaticKeepAliveClientMixin {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _muslimController = TextEditingController();
  final GlobalKey<OderInputFieldState> _fullNameKey = GlobalKey();
  final GlobalKey<OderInputFieldState> _firstNameKey = GlobalKey();
  final GlobalKey<OderInputFieldState> _lastNameKey = GlobalKey();
  final GlobalKey<OderInputFieldState> _dobKey = GlobalKey();
  final GlobalKey<OderInputFieldState> _emailKey = GlobalKey();
  final GlobalKey<OderSelectValueState> _contactKey = GlobalKey();
  final GlobalKey<OderSelectValueState> _genderKey = GlobalKey();
  final GlobalKey<OderInputFieldState> _muslimKey = GlobalKey();

  String selectedCode = '60';
  String errorfield = '';
  String? path, imageBytes;
  String errorFullName = '', errorFirstName = '', errorLastName = '';
  late FocusNode nickFocus, firstFocus, lastFocus, emailFocus;
  String? profileImage;
  bool isProcessing = false;
  bool error = false;
  // ignore: prefer_typing_uninitialized_variables
  bool profileEvalid = false;
  Image? image;
  // ignore: unused_field
  late File _image;
  var photoBloc = PhotoBloc();
  List<String> getGender = ["Male", "Female"];
  List<String> getMuslim = [
    "Muslim-Friendly Content Only",
    "Include Non-Halal Content",
  ];
  String dropdownValue = 'One';
  final ImagePicker _picker = ImagePicker();
  // Track whether initial hydration has occurred
  bool _isInitialHydration = true;

  void setProcessingStatus(bool processing) {
    setState(() {
      isProcessing = processing;
    });
  }

  @override
  void initState() {
    super.initState();

    initializeDateFormatting();
    nickFocus = FocusNode();
    firstFocus = FocusNode();
    lastFocus = FocusNode();
    emailFocus = FocusNode();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _lastNameController.dispose();
    _firstNameController.dispose();
    _emailController.dispose();

    // Clean up the focus node when the Form is disposed.
    nickFocus.dispose();
    firstFocus.dispose();
    lastFocus.dispose();
    emailFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // super.build(context);

    var sizeBetween = ScreenSize.height / 20;

    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLoaded) {
          // _setProfileData(state);
          // Only hydrate controllers if it's the initial load or user explicitly discarded changes
          if (_isInitialHydration) {
            _setProfileData(state);
            _isInitialHydration = false;
          } else {
            // Optionally update only non-input state (e.g. read-only fields or image URL)
            setState(() {
              profileImage = state.userProfile.profile?.image;
            });
          }
        }

        if (state is ProfileMaintenanceError) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            OderRoutes.maintenanceScreen,
            (Route<dynamic> route) => false,
            arguments: MaintenanceParameters(message: state.message),
          );
        }
        if (state is ProfileError) {
          setProcessingStatus(false);
          // ignore: unnecessary_null_comparison
          state.error != null ? error = true : error = false;
          showErrorToast(state.error, context);
        }

        if (state is ProfileEditLoaded) {
          errorfield = state.errorField;
        }
        if (state is ProfileUpdated) {
          setProcessingStatus(false);
          // FocusScope.of(context).unfocus();

          BlocProvider.of<ProfileBloc>(context).add(ProfileLoad());
          showSuccessToast('Update was successful.', context);
        }
        if (state is ProfilePhotoUpdated) {
          setProcessingStatus(false);
          BlocProvider.of<ProfileBloc>(context).add(ProfileLoad());
          showSuccessToast('Profile photo updated.', context);
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: Theme(
            data: ThemeData(
              textSelectionTheme: TextSelectionThemeData(
                cursorColor: errorfield == '' ? colorDarkGray : colorRed,
              ),
            ),

            child: SingleChildScrollView(
              child: Container(
                color: colorWhite,
                margin: EdgeInsets.symmetric(horizontal: marginHorizontal),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    BlocProvider<PhotoBloc>.value(
                      value: photoBloc,
                      child: BlocConsumer<PhotoBloc, PhotoState>(
                        listener: (context, photoState) {
                          if (photoState is PhotoSet) {
                            _showPhotoConfirmDialog(context, photoState.photo);
                          }
                        },
                        builder: (context, photoState) {
                          Image? image;
                          // print('PHOTO BUILDER: $state');

                          // if (state is ProfileLoaded) {
                          //   BlocProvider.of<ProfileBloc>(context)
                          //       .add(ProfileLoad());
                          // }

                          if (profileImage != null) {
                            // image = profileImage!;
                            image = Image.network(
                              profileImage!,
                              fit: BoxFit.fitWidth,
                            );
                          } else {
                            image = Image.asset('assets/icons/no_photo.png');
                          }

                          return Center(
                            child: Stack(
                              children: [
                                Container(
                                  height: ScreenSize.height / 5.8,
                                  color: colorBackground,
                                  child: AspectRatio(
                                    aspectRatio: 1 / 1,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        // color: colorBabyBlue,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          width: ScreenSize.width * 0.008,
                                          color: colorBorderGray,
                                        ),
                                      ),
                                      child: ClipOval(child: image),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 6,
                                  bottom: 0.0,
                                  child: InkWell(
                                    onTap: () => _showSelectionDialog(context),
                                    child: Container(
                                      height: ScreenSize.height * 0.05,
                                      width: ScreenSize.height * 0.05,
                                      decoration: BoxDecoration(
                                        color: colorWhite,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          width: ScreenSize.width * 0.008,
                                          color: colorBorderGray,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.camera_alt_outlined,
                                        color: mainColor,
                                        size: 25.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: sizeBetween * 0.5),
                    /* ----------------------------------------------------------- Nickname input field */
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Text(
                        'Display Name',
                        style: TextStyle(
                          fontFamily: fontFamilyMain,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    OderRoundField(
                      horizontalPadding: 0,
                      focusBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color:
                              error
                                  ? colorRed
                                  : errorfield == 'error' ||
                                      errorfield == 'errornick'
                                  ? colorRed
                                  : colorUsedGray,
                        ),
                        // borderRadius: BorderRadius.circular(25.0),
                      ),
                      key: _fullNameKey,
                      controller: _fullNameController,
                      labelStyle: TextStyle(
                        color:
                            error
                                ? colorRed
                                : errorfield == 'error' ||
                                    errorfield == 'errornick'
                                ? colorRed
                                : colorUsedGray,
                        fontSize: 13,
                      ),
                      textCapitalization: TextCapitalization.words,
                      validator: Validator.valueExists,
                      keyboard: TextInputType.text,
                      border: InputBorder.none,
                      focusNode: nickFocus,
                      onValueChanged: (value) {
                        if (state is ProfileEditLoaded && value != '') {
                          errorfield = '';
                          BlocProvider.of<ProfileBloc>(
                            context,
                          ).add(ProfileEditLoad(errorField: errorfield));
                        }
                      },
                    ),
                    errorfield == 'error' || errorfield == 'errornick'
                        ? Container(
                          margin: EdgeInsets.only(top: 5),
                          child: Text(
                            errorFullName,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color:
                                  error
                                      ? colorRed
                                      : errorfield == 'error' ||
                                          errorfield == 'errornick'
                                      ? colorRed
                                      : colorGreyBox,
                            ),
                          ),
                        )
                        : SizedBox(),
                    /* ----------------------------------------------------------- Firstname/Forename input field */
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: Text(
                        'First Name',
                        style: TextStyle(
                          fontFamily: fontFamilyMain,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 17),
                      child: OderRoundField(
                        focusBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color:
                                error
                                    ? colorRed
                                    : errorfield == 'error' ||
                                        errorfield == 'errorfirst'
                                    ? colorRed
                                    : colorUsedGray,
                          ),
                          // borderRadius: BorderRadius.circular(25.0),
                        ),
                        key: _firstNameKey,
                        controller: _firstNameController,
                        labelStyle: TextStyle(
                          color:
                              error
                                  ? colorRed
                                  : errorfield == 'error' ||
                                      errorfield == 'errorfirst'
                                  ? colorRed
                                  : colorUsedGray,
                          fontSize: 13,
                        ),
                        textCapitalization: TextCapitalization.words,
                        validator: Validator.valueExists,
                        keyboard: TextInputType.text,
                        border: InputBorder.none,
                        focusNode: firstFocus,
                        onValueChanged: (value) {
                          if (state is ProfileEditLoaded && value != '') {
                            errorfield = '';
                            BlocProvider.of<ProfileBloc>(
                              context,
                            ).add(ProfileEditLoad(errorField: errorfield));
                          }
                        },
                      ),
                    ),
                    errorfield == 'error' || errorfield == 'errorfirst'
                        ? Container(
                          margin: EdgeInsets.only(top: 5),
                          child: Text(
                            errorFirstName,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color:
                                  error
                                      ? colorRed
                                      : errorfield == 'error' ||
                                          errorfield == 'errorfirst'
                                      ? colorRed
                                      : colorGreyBox,
                            ),
                          ),
                        )
                        : SizedBox(),
                    /* ----------------------------------------------------------- Last Name/ Surname input field */
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: Text(
                        'Last Name',
                        style: TextStyle(
                          fontFamily: fontFamilyMain,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 17),
                      child: OderRoundField(
                        focusBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color:
                                error
                                    ? colorRed
                                    : errorfield == 'error' ||
                                        errorfield == 'errorlast'
                                    ? colorRed
                                    : colorUsedGray,
                          ),
                          // borderRadius: BorderRadius.circular(25.0),
                        ),
                        key: _lastNameKey,
                        controller: _lastNameController,
                        labelStyle: TextStyle(
                          color:
                              error
                                  ? colorRed
                                  : errorfield == 'error' ||
                                      errorfield == 'errorlast'
                                  ? colorRed
                                  : colorUsedGray,
                          fontSize: 13,
                        ),
                        textCapitalization: TextCapitalization.words,
                        validator: Validator.valueExists,
                        keyboard: TextInputType.text,
                        border: InputBorder.none,
                        focusNode: lastFocus,
                        onValueChanged: (value) {
                          if (state is ProfileEditLoaded && value != '') {
                            errorfield = '';
                            BlocProvider.of<ProfileBloc>(
                              context,
                            ).add(ProfileEditLoad(errorField: errorfield));
                          }
                        },
                      ),
                    ),
                    errorfield == 'error' || errorfield == 'errorlast'
                        ? Container(
                          margin: EdgeInsets.only(top: 5),
                          child: Text(
                            errorLastName,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color:
                                  error
                                      ? colorRed
                                      : errorfield == 'error' ||
                                          errorfield == 'errorlast'
                                      ? colorRed
                                      : colorGreyBox,
                            ),
                          ),
                        )
                        : SizedBox(),
                    /* ----------------------------------------------------------- Email input field */
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: Text(
                        'Email',
                        style: TextStyle(
                          fontFamily: fontFamilyMain,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    _buildVerifiedEmail(state),
                    /* ----------------------------------------------------------- Muslim Friendly input field */
                    isMuslimFriendly == true
                        ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                              child: Text(
                                'Please select one:',
                                style: TextStyle(
                                  fontFamily: fontFamilyMain,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 17, 0, 0),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.all(
                                  Radius.circular(4),
                                ),
                              ),
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 15.0,
                                  ),
                                  fillColor: Colors.grey[200],
                                  labelStyle: TextStyle(
                                    fontSize: 13,
                                    fontFamily: fontFamilyMain,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(4),
                                    ),
                                  ),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: ButtonTheme(
                                    child: DropdownButton<String>(
                                      key: _muslimKey,
                                      value:
                                          _muslimController.text == ''
                                              ? null
                                              : _muslimController.text ==
                                                  'Muslim-Friendly Content Only'
                                              ? 'Muslim-Friendly Content Only'
                                              : 'Include Non-Halal Content',
                                      items:
                                          getMuslim.map<
                                            DropdownMenuItem<String>
                                          >((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                value,
                                                style: TextStyle(
                                                  color: colorBlack,
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 16,
                                                  fontFamily: fontFamilyMain,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                      onChanged: null,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                        : Container(),
                    // /* ----------------------------------------------------------- Mobile No input field */
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: Text(
                        'Mobile No',
                        style: TextStyle(
                          fontFamily: fontFamilyMain,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 17),
                      child: OderRoundField(
                        focusBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: colorUsedGray),
                          // borderRadius: BorderRadius.circular(25.0),
                        ),
                        key: _contactKey,
                        controller: _contactController,
                        labelStyle: TextStyle(
                          color: colorUsedGray,
                          fontSize: 13,
                        ),
                        validator: Validator.valueExists,
                        keyboard: TextInputType.text,
                        border: InputBorder.none,
                        readOnly: true,
                        textAlignVertical: TextAlignVertical.center,
                      ),
                    ),
                    /* ----------------------------------------------------------- Gender input field */
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: Text(
                        'Gender',
                        style: TextStyle(
                          fontFamily: fontFamilyMain,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 17, 0, 0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 15.0,
                          ),
                          fillColor: Colors.grey[200],
                          labelStyle: TextStyle(
                            fontSize: 13,
                            fontFamily: fontFamilyMain,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            child: DropdownButton<String>(
                              key: _genderKey,
                              value:
                                  _genderController.text == 'male'
                                      ? 'Male'
                                      : 'Female',
                              items:
                                  getGender.map<DropdownMenuItem<String>>((
                                    String value,
                                  ) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: TextStyle(
                                          color: colorBlack,
                                          fontWeight: FontWeight.w300,
                                          fontSize: 16,
                                          fontFamily: fontFamilyMain,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                              onChanged: null,
                            ),
                          ),
                        ),
                      ),
                    ),
                    /* ----------------------------------------------------------- Date of Birth input field */
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: Text(
                        'DOB',
                        style: TextStyle(
                          fontFamily: fontFamilyMain,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 17),
                      child: OderRoundField(
                        focusBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: colorUsedGray),
                          // borderRadius: BorderRadius.circular(25.0),
                        ),
                        key: _dobKey,
                        controller: _dobController,
                        labelStyle: TextStyle(
                          color: colorUsedGray,
                          fontSize: 13,
                        ),
                        validator: Validator.valueExists,
                        keyboard: TextInputType.text,
                        border: InputBorder.none,
                        readOnly: true,
                        textAlignVertical: TextAlignVertical.center,
                      ),
                    ),
                    /* ----------------------------------------------------------- Save changes button */
                    Container(
                      alignment: Alignment.bottomCenter,
                      margin: EdgeInsets.only(top: 20),
                      child: OderStyleButton(
                        height: ScreenSize.height / 14,
                        title:
                            isProcessing
                                ? 'Processing...'
                                : 'Save'.toUpperCase(),
                        backgroundColor:
                            isProcessing ? colorLightGray : colorBlackTab,
                        textColor: isProcessing ? colorDarkGray : colorWhite,
                        onPressed:
                            isProcessing
                                ? () {}
                                : () {
                                  _validateAndUpdatePersonal();
                                }, //_validateAndSend,
                      ),
                    ),
                    /* ----------------------------------------------------------- Acc Deletion button */
                    InkWell(
                      child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.symmetric(vertical: 30),
                        child: Text(
                          'Delete My Account',
                          style: TextStyle(
                            fontFamily: fontFamilyMain,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: colorRedLight,
                            decoration: TextDecoration.underline,
                          ),
                          textScaler: TextScaler.linear(scaleFactor),
                        ),
                      ),
                      onTap: () {
                        Navigator.of(
                          context,
                        ).pushNamed(OderRoutes.deleteAccount).then((value) {
                          if (!context.mounted) return;
                          BlocProvider.of<ProfileBloc>(
                            context,
                          ).add(ProfileLoad());
                        });
                      },
                    ),
                    SizedBox(height: ScreenSize.height * 0.05),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildVerifiedEmail(ProfileState profileState) {
    return Container(
      margin: EdgeInsets.only(top: 17),
      child: OderRoundField(
        focusBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color:
                error
                    ? colorRed
                    : errorfield == 'error' || errorfield == 'erroremail'
                    ? colorRed
                    : colorUsedGray,
          ),
          // borderRadius: BorderRadius.circular(25.0),
        ),
        key: _emailKey,
        controller: _emailController,
        labelStyle: TextStyle(
          color:
              error
                  ? colorRed
                  : errorfield == 'error' || errorfield == 'erroremail'
                  ? colorRed
                  : colorUsedGray,
          fontSize: 13,
        ),
        validator: Validator.valueExists,
        keyboard: TextInputType.text,
        border: InputBorder.none,
        // suffixIcon: Container(
        //     margin: EdgeInsets.only(right: 10),
        //     child: _buildVerifyEmail(context, profileState)),
        readOnly: profileEvalid ? true : false,
        textAlignVertical: TextAlignVertical.center,
        focusNode: emailFocus,
        onValueChanged: (value) {
          if (profileState is ProfileEditLoaded && value != '') {
            errorfield = '';
            BlocProvider.of<ProfileBloc>(
              context,
            ).add(ProfileEditLoad(errorField: errorfield));
          }
        },
      ),
    );
  }

  // Widget _buildVerifyEmail(BuildContext context, ProfileState profileState) {
  //   if (!profileEvalid) {
  //     return Container(
  //       // color: colorBackground,
  //       width: MediaQuery.of(context).size.width * 0.16,
  //       alignment: Alignment.centerRight,
  //       child: OderTextButton(
  //         'Verify Email',
  //         fontSize: 10,
  //         color: colorLightBlue,
  //         padding: EdgeInsets.zero,
  //         onClick: () {
  //           Navigator.of(context).pushNamed( OderRoutes.verifyEmail,
  //               arguments: VerifyEmailParameters(email: Storage().verifyEmail));
  //         },
  //       ),
  //     );
  //   } else {
  //     return Container(
  //       // color: colorLightBlue,
  //       width: MediaQuery.of(context).size.width * 0.16,
  //       alignment: Alignment.centerRight,
  //       child: Text(
  //         'Verified',
  //         style: TextStyle(
  //           fontSize: 10,
  //           color: secondaryColor,
  //         ),
  //         textScaler: TextScaler.linear(scaleFactor),
  //       ),
  //     );
  //   }
  // }

  Future _showSelectionDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          contentPadding: EdgeInsets.fromLTRB(24, 12, 24, 16),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select photo',
                style: TextStyle(
                  fontSize: 16,
                  color: mainColor,
                  fontWeight: FontWeight.w600,
                ),
                textScaler: TextScaler.linear(scaleFactor),
              ),
              Divider(thickness: 1, color: Colors.grey.shade300),
            ],
          ),
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: InkWell(
                child: Text(
                  'Take Photo',
                  style: TextStyle(
                    fontSize: 14,
                    color: mainColor,
                    // fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.pop(context);
                },
              ),
            ),
            SizedBox(height: marginHorizontal),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: InkWell(
                child: Text(
                  'Pick from Gallery',
                  style: TextStyle(
                    fontSize: 14,
                    color: mainColor,
                    // fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
              ),
            ),
            SizedBox(height: marginHorizontal),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: InkWell(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 14,
                    color: colorRed,
                    // fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () => Navigator.pop(context),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxHeight: 300,
        maxWidth: 300,
      );

      // Guard against screen unmount while user is picking an image
      if (!mounted || pickedFile == null) return;

      // Await cropping before updating state
      await _cropImage(File(pickedFile.path));
    } catch (e) {
      // print("Error picking image: $e");
    }
  }

  Future<void> _cropImage(File imageFile) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      // aspectRatioPresets removed. Use aspectRatio instead.
      // aspectRatio:
      //     CropAspectRatio(ratioX: 1, ratioY: 1), //Example of a 1:1 ratio.
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Image Cropper',
          toolbarColor: colorBlack,
          backgroundColor: colorBlack,
          hideBottomControls: true,
          toolbarWidgetColor: colorWhite,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: false,
          dimmedLayerColor: colorTransparent,
        ),
        IOSUiSettings(title: 'Image Cropper'),
      ],
    );

    // Guard against screen unmount during crop step
    if (!mounted || croppedFile == null) return;

    final File cropped = File(croppedFile.path);

    setState(() {
      _image = cropped;
      // photoBloc.add(GetPhoto(photo: _image));
    });

    photoBloc.add(GetPhoto(photo: cropped));
  }

  Future _showPhotoConfirmDialog(BuildContext context, File photo) {
    var bytes = photo.readAsBytesSync();
    imageBytes = base64Encode(bytes);

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(10.0),
          backgroundColor: colorWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          title: Column(
            children: [
              Text(
                'Upload Photo Confirmation',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
                textScaler: TextScaler.linear(scaleFactor),
              ),
              Divider(thickness: 1, color: Colors.grey.shade300),
            ],
          ),
          content: Container(
            color: colorWhite,
            height: MediaQuery.of(context).size.height * 0.35,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    width: ScreenSize.height / 5.5,
                    height: ScreenSize.height / 5.5,
                    decoration: BoxDecoration(
                      color: colorTransparent,
                      // shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: Image.file(photo).image,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OderStyleButton(
                          backgroundColor: mainColor,
                          height: ScreenSize.height / 14,
                          width: ScreenSize.width,
                          title: 'Update Profile Photo',
                          onPressed: _confirmUpdatePhoto,
                          // () {
                          //   var bytes = photo.readAsBytesSync();
                          //   var image = base64Encode(bytes);
                          //   BlocProvider.of<ProfileBloc>(context)
                          //       .add(ProfilePhotoUpdate(image: image));

                          //   Timer(Duration(seconds: 1), () {
                          //     Navigator.pop(context);
                          //   });
                          // },
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 5, top: 10),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: colorRed,
                                decoration: TextDecoration.underline,
                              ),
                              textScaler: TextScaler.linear(scaleFactor),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirmUpdatePhoto() {
    Navigator.pop(context);

    BlocProvider.of<ProfileBloc>(
      context,
    ).add(ProfilePhotoUpdate(image: imageBytes!));
  }

  void _validateAndUpdatePersonal() {
    if (!mounted) return;
    setState(() {
      fToast = FToast();
      fToast.init(context);
    });

    if (_fullNameController.text.isEmpty) {
      errorfield = 'errornick';
      nickFocus.requestFocus();
      errorFullName = 'Nickname is required!';
      // showErrorToast('Nickname cannot be empty', context);

      BlocProvider.of<ProfileBloc>(
        context,
      ).add(ProfileEditLoad(errorField: errorfield));
    } else if (_firstNameController.text.isEmpty) {
      errorfield = 'errorfirst';
      firstFocus.requestFocus();
      errorFirstName = 'First Name is required!';
      // showErrorToast('First Name/ Forname cannot be empty', context);

      BlocProvider.of<ProfileBloc>(
        context,
      ).add(ProfileEditLoad(errorField: errorfield));
    } else if (_lastNameController.text.isEmpty) {
      errorfield = 'errorlast';
      lastFocus.requestFocus();
      errorLastName = 'Last Name is required!';
      // showErrorToast('Last Name/ Surname cannot be empty', context);
      // ErrorDialog.showErrorDialog(
      //     context, 'Last Name/ Surname cannot be empty');

      BlocProvider.of<ProfileBloc>(
        context,
      ).add(ProfileEditLoad(errorField: errorfield));
    } else if (_emailController.text.isEmpty) {
      errorfield = 'erroremail';
      emailFocus.requestFocus();
      showErrorToast('Email cannot be empty', context);
      // ErrorDialog.showErrorDialog(context, 'Email cannot be empty');

      BlocProvider.of<ProfileBloc>(
        context,
      ).add(ProfileEditLoad(errorField: errorfield));
    } else {
      setProcessingStatus(true);
      BlocProvider.of<ProfileBloc>(context).add(
        ProfileUpdate(
          surname: _lastNameController.text.trim(),
          forename: _firstNameController.text.trim(),
          name: _fullNameController.text.trim(),
          email: _emailController.text.trim(),
          dob:
              _dobController.text.trim().isEmpty
                  ? ''
                  : _dobController.text.trim(),
          gender: _genderController.text.trim(),
        ),
      );
    }
  }

  void _setProfileData(ProfileState state) {
    var profile = (state as ProfileLoaded).userProfile.profile;
    if (profile == null) return;

    String formattedDob = '';

    // // ignore: prefer_typing_uninitialized_variables
    // var dateFormate;

    if (profile.dob!.isNotEmpty) {
      try {
        final parsedDate = DateTime.parse(profile.dob!);
        formattedDob = DateFormat(appDateFormat).format(parsedDate);
      } catch (_) {
        formattedDob = profile.dob!; // Fallback to raw string if parsing fails
      }

      // late var formatter = DateFormat(appDateFormat);
      // dateFormate = formatter.format(DateTime.parse(profile.dob!));
    }
    // else {
    //   var dateNow = DateTime.now();
    //   late var formatter = DateFormat(appDateFormat);
    //   dateFormate = formatter.format(
    //     DateTime(dateNow.year - minAgeDOB, dateNow.month, dateNow.day),
    //   );
    // }

    // // ignore: unnecessary_null_comparison
    // if (profile != null) {
    _fullNameController.text = profile.name ?? '';
    _firstNameController.text = profile.forename ?? '';
    _lastNameController.text = profile.surname ?? '';
    _dobController.text = formattedDob;
    _emailController.text = profile.email ?? '';
    _contactController.text = profile.contact ?? '';
    _genderController.text = profile.gender ?? '';
    profileEvalid = profile.eValid ?? false;
    // Storage().verifyEmail = profile.email!;
    profileImage = profile.image;

    if (profileImage != null) {
      // image = profileImage!;
      image = Image.network(profileImage!, fit: BoxFit.fitWidth);
    } else {
      image = Image.asset('assets/icons/no_photo.png');
    }

    _muslimController.text =
        profile.isMuslim == null
            ? 'Include Non-Halal Content'
            // ignore: unrelated_type_equality_checks
            : profile.isMuslim == true || profile.isMuslim == '1'
            ? 'Muslim-Friendly Content Only'
            : 'Include Non-Halal Content';
    // }
  }

  // @override
  // bool get wantKeepAlive => true;
}
