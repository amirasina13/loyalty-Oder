import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app_setting/app_setting.dart';
import '../../../../locator.dart';
import '../../../widgets/widgets.dart';
import '../../country/country.dart';
import '../../home/home.dart';
import '../../profile/profile.dart';
import '../../wallet/wallet.dart';
import '../authentication.dart';

class OnBoard2View extends StatefulWidget {
  const OnBoard2View({super.key});

  @override
  State<OnBoard2View> createState() => _OnBoard2ViewState();
}

class _OnBoard2ViewState extends State<OnBoard2View> {
  int currentPage = 0;
  double dragStartX = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationBloc>(
      create:
          (context) => AuthenticationBloc(
            profileBloc: BlocProvider.of<ProfileBloc>(context),
            homeBloc: BlocProvider.of<HomeBloc>(context),
            walletBloc: BlocProvider.of<WalletBloc>(context),
            countryBloc: BlocProvider.of<CountryBloc>(context),
            userRepository: sl(),
            globalRepository: sl(),
          ),
      child: Scaffold(
        backgroundColor: colorWhite,
        body: Container(
          height: ScreenSize.height,
          width: ScreenSize.width,
          padding: EdgeInsets.fromLTRB(
            marginHorizontal,
            ScreenSize.height * 0.115,
            marginHorizontal,
            0,
          ),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/image/onboard2.webp'),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(
                image: AssetImage(mainLogo),
                height: ScreenSize.height * 0.13,
              ),
              SizedBox(
                height: ScreenSize.height * 0.55,
                child: SlideInformationWidget(
                  slides: [
                    SlideInfo(
                      title: '🎁 Get More Deals',
                      description:
                          'By subscribing to our Loyalty Program, you\'ll unlock access to the best deals and never miss out on exclusive offers and promotions.',
                      image: Image(
                        image: AssetImage('assets/image/img_board2.webp'),
                        height: ScreenSize.height * 0.25,
                      ),
                    ),
                    SlideInfo(
                      title: 'Congrats, you\'re in! 🎉',
                      description:
                          'More amazing deals are waiting for you — dive in now and start saving on your favorite items!',
                      image: Image(
                        image: AssetImage('assets/image/img_board3.webp'),
                        height: ScreenSize.height * 0.33,
                      ),
                    ),
                    SlideInfo(title: '', description: ''),
                  ],
                  titleStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  descriptionStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                  backgroundColor: Colors.white,
                  indicatorColor: Colors.grey[300],
                  activeIndicatorColor: Colors.blue,
                ),
              ),
              Expanded(
                child: InkWell(
                  child: Container(
                    alignment: Alignment.bottomLeft,
                    margin: EdgeInsets.fromLTRB(
                      15,
                      0,
                      15,
                      ScreenSize.height * 0.07,
                    ),
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: fontFamilyMain,
                        color: colorBlackText,
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      PageRouteBuilder(
                        pageBuilder:
                            (context, animation, secondaryAnimation) =>
                                LoadingOnboard(),
                      ),
                      ModalRoute.withName('/'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
