import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './utils/constant.dart';
import './utils/custom_widget.dart';
import './blocs/bloc_provider.dart';
import './blocs/login_bloc.dart';
import './ui/home_screen.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation _animation;

  int _duration;
  double _logoSize;
  @override
  void initState() {
    super.initState();
    _animationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 1200));
    _animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.easeInCirc));
    _animationController.forward();

    _duration = 2500;
    _logoSize = 250;
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<LoginBloc>(context);
    Future.delayed(Duration(milliseconds: _duration), () => bloc.loadLogin())
        .then((value) => _navigator());
    return Scaffold(
      body: Stack(
        children: <Widget>[
          CustomWidget.buildImageBackground(context),
          _buildLogo(),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return FadeTransition(
      opacity: _animation,
      child: Center(
        child: SizedBox(
          height: _logoSize,
          child: Image.asset(logoImagePath),
        ),
      ),
    );
  }

  void _navigator() => Navigator.of(context).pushReplacement(CupertinoPageRoute(
        builder: (context) => HomeScreen(),
      ));
}
