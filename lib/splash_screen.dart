import 'package:flutter/material.dart';
import './blocs/bloc_provider.dart';
import './blocs/login_bloc.dart';
import './ui/home_screen.dart';
import './utils/custom_splash_screen.dart';

// ignore: must_be_immutable
class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<LoginBloc>(context);
    return CustomSplash(
      home: HomeScreen(),
      type: CustomSplashType.BackgroundProcess,
      imagePath: 'assets/images/app_icon.png',
      duration: 2500,
      logoSize: 200,
      backgroundImage: 'assets/images/img_bg.jpg',
      customFunction: bloc.loadLogin(),
    );
  }
}
