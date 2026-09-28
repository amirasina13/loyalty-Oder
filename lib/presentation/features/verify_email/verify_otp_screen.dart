// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../../config/config.dart';
// import '../../../data/data.dart';
// import '../../widgets/widgets.dart';
// import '../profile/profile.dart';
// import '../wrapper.dart';
// import 'verify_email.dart';

// class VerifyEmailOtpParameters {
//   final dynamic registerData;

//   const VerifyEmailOtpParameters({required this.registerData});
// }

// class VerifyEmailOtpScreen extends StatefulWidget {
//   final VerifyEmailOtpParameters parameters;

//   const VerifyEmailOtpScreen({super.key, required this.parameters});

//   @override
//   State<VerifyEmailOtpScreen> createState() => _VerifyEmailOtpScreenState();
// }

// class _VerifyEmailOtpScreenState extends State<VerifyEmailOtpScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ProfileBloc, ProfileState>(
//       builder: (context, state) {
//         if (state is ProfileProcessing) {
//           return Container(
//             height: MediaQuery.of(context).size.height,
//             width: MediaQuery.of(context).size.width,
//             color: colorWhite,
//             child: LoadingWidget(),
//           );
//         }
//         return GestureDetector(
//           onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
//           child: Scaffold(
//             backgroundColor: colorWhite,
//             body: BlocProvider<VerifyEmailBloc>(
//               create: (context) {
//                 return VerifyEmailBloc(
//                   userRepository: RepositoryProvider.of<UserRepository>(
//                     context,
//                   ),
//                 );
//               },
//               child: VerifyEmailOtpWrapper(
//                 registerData: widget.parameters.registerData,
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// class VerifyEmailOtpWrapper extends StatefulWidget {
//   final dynamic registerData;

//   const VerifyEmailOtpWrapper({super.key, required this.registerData});

//   @override
//   OderWrapperState<VerifyEmailOtpWrapper> createState() =>
//   // ignore: no_logic_in_create_state
//   _VerifyEmailOtpWrapperState(registerData);
// }

// class _VerifyEmailOtpWrapperState
//     extends OderWrapperState<VerifyEmailOtpWrapper> {
//   final dynamic registerData;

//   _VerifyEmailOtpWrapperState(this.registerData);

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<VerifyEmailBloc, VerifyEmailState>(
//       builder: (context, state) {
//         return getPageView(<Widget>[
//           EmailOtpView(changeView: changePage, registerData: registerData),
//         ]);
//       },
//     );
//   }
// }
