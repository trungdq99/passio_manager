import 'dart:async';

import 'package:flutter/material.dart';

Widget _home;
Future _customFunction;
String _imagePath;
int _duration;
CustomSplashType _runfor;
Color _backgroundColor;
String _backgroundImage;
String _animationEffect;
double _logoSize;

enum CustomSplashType { StaticDuration, BackgroundProcess }

Map<dynamic, Widget> _outputAndHome = {};

class CustomSplash extends StatefulWidget {
  CustomSplash(
      {@required String imagePath,
      @required Widget home,
      Future customFunction,
      int duration,
      CustomSplashType type,
      Color backgroundColor = Colors.white,
      String backgroundImage = '',
      String animationEffect = 'fade-in',
      double logoSize = 250.0,
      Map<int, Widget> outputAndHome}) {
    assert(duration != null);
    assert(home != null);
    assert(imagePath != null);

    _home = home;
    _duration = duration;
    _customFunction = customFunction;
    _imagePath = imagePath;
    _runfor = type;
    _outputAndHome = outputAndHome;
    _backgroundColor = backgroundColor;
    _backgroundImage = backgroundImage;
    _animationEffect = animationEffect;
    _logoSize = logoSize;
  }

  @override
  _CustomSplashState createState() => _CustomSplashState();
}

class _CustomSplashState extends State<CustomSplash>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation _animation;

  @override
  void initState() {
    super.initState();
    if (_duration < 1000) _duration = 2000;
    _animationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 1200));
    _animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.easeInCirc));
    _animationController.forward();
    _customFunction.then((value) => Timer(
        Duration(milliseconds: _duration),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => _home,
            ))));
  }

//  @override
//  void didUpdateWidget(CustomSplash oldWidget) {
//    super.didUpdateWidget(oldWidget);
//    _animationController.duration = Duration(milliseconds: _duration);
//  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  Widget _buildAnimation() {
    switch (_animationEffect) {
      case 'fade-in':
        {
          return FadeTransition(
              opacity: _animation,
              child: Center(
                  child: SizedBox(
                      height: _logoSize, child: Image.asset(_imagePath))));
        }
      case 'zoom-in':
        {
          return ScaleTransition(
              scale: _animation,
              child: Center(
                  child: SizedBox(
                      height: _logoSize, child: Image.asset(_imagePath))));
        }
      case 'zoom-out':
        {
          return ScaleTransition(
              scale: Tween(begin: 1.5, end: 0.6).animate(CurvedAnimation(
                  parent: _animationController, curve: Curves.easeInCirc)),
              child: Center(
                  child: SizedBox(
                      height: _logoSize, child: Image.asset(_imagePath))));
        }
      case 'top-down':
        {
          return SizeTransition(
              sizeFactor: _animation,
              child: Center(
                  child: SizedBox(
                      height: _logoSize, child: Image.asset(_imagePath))));
        }
    }
  }

//  void backgroundProcess() {
//    _customFunction.then((value) {
//      print('Hello');
//      Future.delayed(
//        Duration(milliseconds: _duration),
//      ).then((_) => Navigator.of(context).pushReplacement(MaterialPageRoute(
//            builder: (context) => _home,
//          )));
//    });
//  }

  @override
  Widget build(BuildContext context) {
//    _runfor == CustomSplashType.BackgroundProcess
//        ? backgroundProcess()
//        : Future.delayed(Duration(milliseconds: _duration)).then((value) {
//            Navigator.of(context).pushReplacement(
//                MaterialPageRoute(builder: (context) => _home));
//          });

    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            _backgroundImage,
            fit: BoxFit.fitHeight,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          _buildAnimation(),
        ],
      ),
    );
  }
}
